import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final String userId;

  const MapPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final LatLng _collegeCenter = const LatLng(17.0456, 74.2557);

  final List<LatLng> _collegeBoundary = [
    LatLng(17.046126, 74.254350),
    LatLng(17.046311, 74.255917),
    LatLng(17.045308, 74.256118),
    LatLng(17.044843, 74.254379),
    LatLng(17.046126, 74.254350), // Close the loop
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Live Locations"),
        backgroundColor: Colors.deepPurple,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _collegeCenter,
          zoom: 17,
        ),
        polygons: {
          Polygon(
            polygonId: const PolygonId("college_boundary"),
            points: _collegeBoundary,
            strokeColor: Colors.red,
            strokeWidth: 4,
            fillColor: Colors.red.withOpacity(0.1),
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;

          // Ensure the polygon area stays visible even when zoomed or moved
          double minLat = _collegeBoundary.map((e) => e.latitude).reduce((a, b) => a < b ? a : b);
          double maxLat = _collegeBoundary.map((e) => e.latitude).reduce((a, b) => a > b ? a : b);
          double minLng = _collegeBoundary.map((e) => e.longitude).reduce((a, b) => a < b ? a : b);
          double maxLng = _collegeBoundary.map((e) => e.longitude).reduce((a, b) => a > b ? a : b);

          LatLng southwest = LatLng(minLat, minLng);
          LatLng northeast = LatLng(maxLat, maxLng);

          Future.delayed(const Duration(milliseconds: 300), () {
            mapController.animateCamera(
              CameraUpdate.newLatLngBounds(
                LatLngBounds(southwest: southwest, northeast: northeast),
                100,
              ),
            );
          });
        },
      ),
    );
  }
}
















// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => _MapPageState();
// }
//
// class _MapPageState extends State<MapPage> {
//   late GoogleMapController mapController;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   // College Fence Coordinates
//   final List<LatLng> _collegeBoundary = [
//     LatLng(18.62312697162768, 73.81564343909113),
//     LatLng(18.623335116915683, 73.81661813273318),
//     LatLng(18.622809374203733, 73.81600112653983),
//     LatLng(18.62312697162768, 73.81564343909113), // Closing the polygon
//   ];
//
//   final LatLng _collegeCenter = LatLng(18.626935, 73.815328);
//
//   Set<Marker> _markers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _setupFirebaseMessaging();
//     _fetchUserLocations();
//   }
//
//   // Initialize Firebase Cloud Messaging
//   void _setupFirebaseMessaging() {
//     _firebaseMessaging.requestPermission();
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(
//         message.notification?.title ?? 'Alert',
//         message.notification?.body ?? 'A user has left the college fence',
//       );
//     });
//   }
//
//   // Show notification locally
//   void _showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails('channel_id', 'channel_name', importance: Importance.high, priority: Priority.high);
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
//   }
//
//   // Fetch all user locations from Firestore and update markers
//   void _fetchUserLocations() {
//     _firestore.collection('student').snapshots().listen((snapshot) {
//       Set<Marker> newMarkers = {};
//
//       for (var doc in snapshot.docs) {
//         var data = doc.data();
//
//         // Check if latitude and longitude exist
//         if (data.containsKey('latitude') && data.containsKey('longitude')) {
//           double? lat = double.tryParse(data['latitude'].toString());
//           double? lng = double.tryParse(data['longitude'].toString());
//
//           if (lat != null && lng != null) {
//             LatLng userLocation = LatLng(lat, lng);
//
//             // Add marker
//             newMarkers.add(
//               Marker(
//                 markerId: MarkerId(doc.id),
//                 position: userLocation,
//                 infoWindow: InfoWindow(title: data['firstname'] ?? 'Unknown'),
//               ),
//             );
//
//             print("Marker Added: ${data['firstname']} at ($lat, $lng)");
//           } else {
//             print("Skipping document ${doc.id}: Invalid lat/lng values");
//           }
//         } else {
//           print("Skipping document ${doc.id}: Missing lat/lng fields");
//         }
//       }
//
//       // Update state
//       setState(() {
//         _markers = newMarkers;
//       });
//     });
//   }
//
//   // Check if the point is inside the college fence
//   bool _isInsideCollegeFence(LatLng point) {
//     int count = 0;
//     for (int i = 0, j = _collegeBoundary.length - 1; i < _collegeBoundary.length; j = i++) {
//       if ((_collegeBoundary[i].longitude > point.longitude) !=
//           (_collegeBoundary[j].longitude > point.longitude) &&
//           (point.latitude <
//               (_collegeBoundary[j].latitude - _collegeBoundary[i].latitude) *
//                   (point.longitude - _collegeBoundary[i].longitude) /
//                   (_collegeBoundary[j].longitude - _collegeBoundary[i].longitude) +
//                   _collegeBoundary[i].latitude)) {
//         count++;
//       }
//     }
//     return (count % 2 == 1);
//   }
//
//   // Send notification to admin when a user leaves the fence
//   void _sendNotificationToAdmin(String message) {
//     _firebaseMessaging.subscribeToTopic('admin');
//     _firestore.collection('notifications').add({
//       'title': 'Alert',
//       'body': message,
//       'timestamp': Timestamp.now(),
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Admin Map Page')),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _collegeCenter,
//           zoom: 17.0, // Focus on the college fence area
//         ),
//         polygons: {
//           Polygon(
//             polygonId: PolygonId('college_fence'),
//             points: _collegeBoundary,
//             strokeWidth: 2,
//             strokeColor: Colors.red,
//             fillColor: Colors.red.withOpacity(0.3),
//           ),
//         },
//         markers: _markers, // Display user markers
//         onMapCreated: (GoogleMapController controller) {
//           setState(() {
//             mapController = controller;
//           });
//         },
//       ),
//     );
//   }
// }
