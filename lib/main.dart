import 'package:facultytracker/admin_pages/admin_help.dart';
import 'package:facultytracker/admin_pages/admin_home.dart';
import 'package:facultytracker/admin_pages/admin_login.dart';
import 'package:facultytracker/admin_pages/faculty_approval.dart';
import 'package:facultytracker/admin_pages/faculty_approval_info.dart';
import 'package:facultytracker/admin_pages/faculty_info.dart';
import 'package:facultytracker/admin_pages/leave_applications.dart';
import 'package:facultytracker/admin_pages/map_page.dart';
import 'package:facultytracker/firebase_options.dart';
import 'package:facultytracker/pages/Home.dart';
import 'package:facultytracker/pages/Login.dart';
import 'package:facultytracker/pages/Register.dart';
import 'package:facultytracker/pages/aboutus.dart';
import 'package:facultytracker/pages/settings.dart';
import 'package:facultytracker/pages/user_help.dart';
import 'package:facultytracker/pages/user_home.dart';
import 'package:facultytracker/pages/user_leave.dart';
import 'package:facultytracker/pages/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:facultytracker/utils/local_notification_service.dart';

// The cloud_firestore and firebase_storage packages are used to interact with Firebase Firestore (a NoSQL database) and Firebase Storage (for storing files like images, videos, etc.)


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize local notifications
  await LocalNotificationService.initialize();

  // Set logger level
  Logger.level = Level.debug;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while checking auth state
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            // User is logged in, go to UserHome
            return const UserHome();
          } else {
            // No user logged in, go to Home
            return const Home();
          }
        },
      ),
      routes: {
        '/home': (context) => const Home(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/user_home': (context) => UserHome(),
        '/user_help': (context) => UserHelpPage(),
        '/user_leave': (context) => const UserLeave(),
        '/user_profile': (context) => const ProfilePage(),
        '/aboutus': (context) => const AboutUsPage(),
        '/settings': (context) => const SettingsPage(),
        '/admin_login': (context) => AdminLogin(),
        '/admin_home': (context) => const AdminHome(),
        '/faculty_info': (context) => const FacultyInfoPage(),
        '/leave_applications': (context) => const LeaveApplicationsPage(),
        '/admin_help': (context) => const AdminHelpPage(),
        '/faculty_approval': (context) => const FacultyApproval(),
        '/map_page': (context) => MapPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/faculty_approval_info') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => FacultyApprovalInfoPage(userId: userId),
          );
        }
        return null;
      },
    );
  }
}