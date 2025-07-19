import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:facultytracker/utils/notification_logger.dart';
import 'dart:async';
import 'package:facultytracker/utils/local_notification_service.dart';
import 'package:facultytracker/utils/firestore_utils.dart';

class BackgroundLocationService {
  final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  String? _userId;
  Timer? _serviceCheckTimer;

  Future<void> initialize(String userId) async {
    _userId = userId;
    await _checkPermissionsAndService();
    await _startLocationUpdates();
    _startServiceCheck();
  }

  Future<void> _checkPermissionsAndService() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        await _logLocationDisabled();
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        await _logLocationDisabled();
        return;
      }
    }
  }

  Future<void> _startLocationUpdates() async {
    await _location.changeSettings(
      accuracy: LocationAccuracy.balanced,
      interval: 10000,
      distanceFilter: 10,
    );
    _location.enableBackgroundMode(enable: true);

    _location.onLocationChanged.listen((LocationData locationData) async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && _userId != null) {
          await FirebaseFirestore.instance
              .collection('student')
              .doc(_userId)
              .update({
            'latitude': locationData.latitude,
            'longitude': locationData.longitude,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      } catch (e) {
        print("Error updating location: $e");
      }
    });
  }

  void _startServiceCheck() {
    _serviceCheckTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        await _logLocationDisabled();
        await LocalNotificationService.showNotification(
          "Location Off",
          "Your location is turned off. Please turn it back on.",
        );
      }
    });
  }

  Future<void> _logLocationDisabled() async {
    if (_userId != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('student')
          .doc(_userId)
          .get();
      final userName = userDoc['firstname'] ?? 'Unknown User';

      await NotificationLogger.logToFirebase(
        userId: _userId!,
        userName: userName,
        title: "Location Services Disabled",
        message: "$userName has disabled location services.",
      );
    }
  }

  Future<void> stopLocationUpdates() async {
    _location.enableBackgroundMode(enable: false);
    _serviceCheckTimer?.cancel();
  }
}