import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUtils {
  static Future<void> updateWithRetry({
    required DocumentReference docRef,
    required Map<String, dynamic> data,
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 2),
  }) async {
    int retries = maxRetries;
    while (retries > 0) {
      try {
        await docRef.update(data);
        return;
      } catch (e) {
        retries--;
        if (retries == 0) {
          print("Failed to update Firestore after $maxRetries retries: $e");
          rethrow;
        }
        await Future.delayed(delay);
      }
    }
  }
}