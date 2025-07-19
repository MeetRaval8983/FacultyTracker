import 'package:firebase_database/firebase_database.dart';

class NotificationLogger {
  static Future<void> logToFirebase({
    required String userId,
    required String userName,
    required String title,
    required String message,
  }) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('notifications/$userId').push();

      await ref.set({
        'userId': userId,
        'userName': userName,
        'title': title,
        'message': message,
        'timestamp': ServerValue.timestamp,
      });
    } catch (e) {
      print('Error logging to Realtime Database: $e');
      // Optionally, rethrow if you want to handle errors upstream
      // rethrow;
    }
  }
}