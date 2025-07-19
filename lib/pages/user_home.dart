import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:facultytracker/service/background_location_service.dart';
import 'package:facultytracker/utils/local_notification_service.dart';
import 'package:facultytracker/utils/notification_logger.dart';
import 'package:facultytracker/utils/firestore_utils.dart';
import 'dart:async';


// Without constraints, the GridView assumes infinite height because it’s designed for scrollable content. It doesn’t automatically stop after rendering its items because that’s not how scrollable widgets are intended to behave.
// To limit its height and make it stop after rendering all its items, you can:
// Use shrinkWrap: true for the GridView.
// The shrinkWrap property tells the GridView to measure its height based on its children, instead of assuming infinite space.
// This forces the GridView to stop growing after rendering all its children
// Wrap it in a height-constraining widget like SizedBox or Expanded
// for scrolling whole column add scroll to whole column



// class UserHome extends StatefulWidget {
//   const UserHome({super.key});
//
//   @override
//   State<UserHome> createState() => _UserHomeState();
// }
//
// class _UserHomeState extends State<UserHome> {
//   String name = "";
//   String firstname = "";
//   String lastname = "";
//   String designation = "";
//   String department = "";
//   bool isLoading = true;
//   bool isLocationEnabled = true;
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//     requestLocationPermission();
//     checkLocationServiceStatus();
//     Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
//     Workmanager().registerPeriodicTask("fetchLocationTask", "fetchLocation",
//         frequency: Duration(minutes: 15));
//   }
//
//
//
//   Future<void> checkLocationServiceStatus() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     setState(() {
//       isLocationEnabled = serviceEnabled;
//     });
//
//     if (!serviceEnabled) {
//       showLocationAlert();
//     }
//   }
//
//
//
//   Future<void> requestLocationPermission() async {
//     if (await Permission.location.isDenied) {
//       PermissionStatus status = await Permission.location.request();
//       if (status.isGranted) {
//         fetchAndStoreLocation();
//       } else {
//         showLocationAlert();
//       }
//     } else {
//       fetchAndStoreLocation();
//     }
//   }
//
//
//
//   Future<void> fetchAndStoreLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       final User? user = _auth.currentUser;
//       if (user != null) {
//         await _firestore.collection('student').doc(user.uid).update({
//           'latitude': position.latitude,
//           'longitude': position.longitude,
//           'lastUpdated': FieldValue.serverTimestamp()
//         });
//       }
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }
//
//   void showLocationAlert() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Location Disabled"),
//         content: Text("Please enable location services to continue tracking."),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               await Geolocator.openLocationSettings();
//             },
//             child: Text("Enable"),
//           )
//         ],
//       ),
//     );
//   }
//
//
//   static void callbackDispatcher() {
//     Workmanager().executeTask((task, inputData) async {
//       await Firebase.initializeApp();
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await FirebaseFirestore.instance.collection('student').doc(user.uid).update({
//           'latitude': position.latitude,
//           'longitude': position.longitude,
//           'lastUpdated': FieldValue.serverTimestamp()
//         });
//       }
//       return Future.value(true);
//     });
//   }
//
//   Future<void> fetchUserData() async {
//     try {
//       final User? user = FirebaseAuth.instance.currentUser;
//
//       if (user != null) {
//         final DocumentSnapshot<Map<String, dynamic>> snapshot =
//             await FirebaseFirestore.instance
//                 .collection('student')
//                 .doc(user.uid)
//                 .get();
//
//         if (snapshot.exists) {
//           setState(() {
//             firstname = snapshot.data()?['firstname'] ?? "Unknown";
//             lastname = snapshot.data()?['lastname'] ?? "Unknown";
//             // name = snapshot.data()?['name'] ?? "Unknown";
//             designation = snapshot.data()?['designation'] ?? "Unknown";
//             department = snapshot.data()?['department'] ?? "Unknown";
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       print("Error fetching user data: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//
//
//
//   Future<void> signOut(BuildContext context) async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       print('Sign out failed: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Sign out failed: $e')),
//       );
//     }
//   }
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'DIT Pimpri',
//           style: TextStyle(
//               color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.indigo,
//         iconTheme: IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 signOut(context);
//               },
//               icon: Icon(Icons.logout))
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: EdgeInsets.all(15.0),
//               child: Column(
//                 children: [
//                   Card(
//                     color: Colors.blue,
//                     child: Padding(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             radius: 50,
//                             // backgroundImage: AssetImage('assets/jayhong.png'),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             "$firstname $lastname",
//                             style: TextStyle(
//                                 fontSize: 25,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           Text(
//                             designation,
//                             style: TextStyle(fontSize: 20, color: Colors.white),
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () {},
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.orange,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(15))),
//                                 child: Text(
//                                   'Month Info',
//                                   style: TextStyle(color: Colors.blue),
//                                 ),
//                               ),
//                               SizedBox(width: 20),
//                               ElevatedButton(
//                                 onPressed: () {},
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.greenAccent,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(15))),
//                                 child: Text(
//                                   'Edit Profile',
//                                   style: TextStyle(color: Colors.blue),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.all(20.0),
//                       child: GridView.count(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 20,
//                         mainAxisSpacing: 20,
//                         children: [
//                           userCard(Icons.person, 'Profile', "/user_profile", context),
//                           userCard(Icons.calendar_month, 'Leave application', "/user_leave", context),
//                           userCard(Icons.school, 'College', "", context),
//                           userCard(Icons.settings, 'Settings', "/settings", context),
//                           userCard(Icons.help, 'Help', "/user_help", context),
//                           userCard(Icons.groups, 'About Us', "/aboutus", context),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
//
// Widget userCard(IconData icon, String s, String routeName, BuildContext context) {
//   return GestureDetector(
//     onTap: () {
//       Navigator.pushNamed(context, routeName);
//     },
//     child: Card(
//       color: Colors.blue,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 40,
//             color: Colors.white,
//           ),
//           SizedBox(height: 10),
//           Text(
//             s,
//             style: TextStyle(color: Colors.white),
//           )
//         ],
//       ),
//     ),
//   );
// }

// import 'package:flutter/material.dart';
//
// class UserHome extends StatelessWidget {
//   const UserHome({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         title: Text(
//           'DIT Pimpri',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: Icon(Icons.logout),
//             color: Colors.white,
//           )
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               color: Colors.blueAccent,
//               elevation: 5,
//               shadowColor: Colors.black45,
//               child: Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: NetworkImage(
//                         'https://via.placeholder.com/150', // Example image URL
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Name',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       'Designation',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white70,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {},
//                           child: Text('Month Info'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.orangeAccent,
//                             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 20),
//                         ElevatedButton(
//                           onPressed: () {},
//                           child: Text('Edit Profile'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.greenAccent,
//                             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(top: 20.0),
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 20,
//                   mainAxisSpacing: 20,
//                   children: [
//                     userCard(Icons.person, 'Profile'),
//                     userCard(Icons.calendar_month, 'Leave Application'),
//                     userCard(Icons.school, 'College'),
//                     userCard(Icons.settings, 'Settings'),
//                     userCard(Icons.help, 'Help'),
//                     userCard(Icons.groups, 'About Us'),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget userCard(IconData icon, String s) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       elevation: 5,
//       shadowColor: Colors.black26,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade200, Colors.blue.shade500],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: 40,
//               color: Colors.white,
//             ),
//             SizedBox(height: 15),
//             Text(
//               s,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class UserHome extends StatelessWidget {
//   void _logout() {
//     // Add logout functionality here
//     print("Logged out");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Dashboard"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.exit_to_app),
//             onPressed: _logout,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Profile Card
//               Card(
//                 elevation: 5,
//                 margin: EdgeInsets.only(bottom: 16.0),
//                 child: Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundImage: NetworkImage('https://www.example.com/profile.jpg'), // Replace with the actual image URL
//                       ),
//                       SizedBox(width: 16.0),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'John Doe', // Replace with dynamic user name
//                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           Text('Software Engineer'), // Replace with dynamic user designation
//                           SizedBox(height: 8.0),
//                           Row(
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () {
//                                   // Month Info button functionality
//                                   print("Month Info");
//                                 },
//                                 child: Text('Month Info'),
//                               ),
//                               SizedBox(width: 8.0),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   // Edit Profile button functionality
//                                   print("Edit Profile");
//                                 },
//                                 child: Text('Edit Profile'),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Other 6 Cards
//               _buildCard('Profile', Icons.person),
//               _buildCard('Leave Application', Icons.request_page),
//               _buildCard('College', Icons.school),
//               _buildCard('Settings', Icons.settings),
//               _buildCard('Help', Icons.help),
//               _buildCard('About Us', Icons.info),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard(String title, IconData icon) {
//     return Card(
//       elevation: 5,
//       margin: EdgeInsets.only(bottom: 16.0),
//       child: ListTile(
//         leading: Icon(icon),
//         title: Text(title),
//         onTap: () {
//           // Add functionality for each card here
//           print("$title clicked");
//         },
//       ),
//     );
//   }
// }












// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:workmanager/workmanager.dart';

// class UserHome extends StatefulWidget {
//   const UserHome({super.key});
//
//   @override
//   State<UserHome> createState() => _UserHomeState();
// }
//
// class _UserHomeState extends State<UserHome> {
//   String firstname = "";
//   String lastname = "";
//   String designation = "";
//   String department = "";
//   bool isLoading = true;
//   bool isLocationEnabled = true;
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//     requestLocationPermission();
//     checkLocationServiceStatus();
//     Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
//     Workmanager().registerPeriodicTask("fetchLocationTask", "fetchLocation",
//         frequency: Duration(minutes: 15));
//   }
//
//   Future<void> checkLocationServiceStatus() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     setState(() {
//       isLocationEnabled = serviceEnabled;
//     });
//
//     if (!serviceEnabled) {
//       showLocationAlert();
//     }
//   }
//
//   Future<void> requestLocationPermission() async {
//     if (await Permission.location.isDenied) {
//       PermissionStatus status = await Permission.location.request();
//       if (status.isGranted) {
//         fetchAndStoreLocation();
//       } else {
//         showLocationAlert();
//       }
//     } else {
//       fetchAndStoreLocation();
//     }
//   }
//
//   Future<void> fetchAndStoreLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       final User? user = _auth.currentUser;
//       if (user != null) {
//         await _firestore.collection('student').doc(user.uid).update({
//           'latitude': position.latitude,
//           'longitude': position.longitude,
//           'lastUpdated': FieldValue.serverTimestamp()
//         });
//       }
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }
//
//   void showLocationAlert() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Location Disabled"),
//         content: Text("Please enable location services to continue tracking."),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               await Geolocator.openLocationSettings();
//             },
//             child: Text("Enable"),
//           )
//         ],
//       ),
//     );
//   }
//
//   static void callbackDispatcher() {
//     Workmanager().executeTask((task, inputData) async {
//       await Firebase.initializeApp();
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await FirebaseFirestore.instance.collection('student').doc(user.uid).update({
//           'latitude': position.latitude,
//           'longitude': position.longitude,
//           'lastUpdated': FieldValue.serverTimestamp()
//         });
//       }
//       return Future.value(true);
//     });
//   }
//
//   Future<void> fetchUserData() async {
//     try {
//       final User? user = FirebaseAuth.instance.currentUser;
//
//       if (user != null) {
//         final DocumentSnapshot<Map<String, dynamic>> snapshot =
//         await FirebaseFirestore.instance
//             .collection('student')
//             .doc(user.uid)
//             .get();
//
//         if (snapshot.exists) {
//           setState(() {
//             firstname = snapshot.data()?['firstname'] ?? "Unknown";
//             lastname = snapshot.data()?['lastname'] ?? "Unknown";
//             designation = snapshot.data()?['designation'] ?? "Unknown";
//             department = snapshot.data()?['department'] ?? "Unknown";
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       print("Error fetching user data: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> signOut(BuildContext context) async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       print('Sign out failed: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Sign out failed: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/dit.png'),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.brown.shade900.withOpacity(0.5), // Warm overlay
//               BlendMode.dstATop,
//             ),
//           ),
//         ),
//         child: SafeArea(
//           child: isLoading
//               ? Center(child: CircularProgressIndicator(color: Colors.blueGrey.shade700))
//               : SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'DIT Pimpri',
//                         style: TextStyle(
//                           color: Colors.blueGrey.shade800,
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           shadows: [
//                             Shadow(
//                               color: Colors.black54,
//                               offset: Offset(2, 2),
//                               blurRadius: 4,
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () => signOut(context),
//                         icon: Icon(Icons.logout, color: Colors.blueGrey.shade800),
//                         iconSize: 28,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   Card(
//                     elevation: 8,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     color: Colors.brown.shade50, // Light beige card
//                     child: Padding(
//                       padding: EdgeInsets.all(20),
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             radius: 50,
//                             backgroundColor: Colors.brown.shade100,
//                             child: Icon(
//                               Icons.person,
//                               size: 50,
//                               color: Colors.brown.shade800,
//                             ),
//                           ),
//                           SizedBox(height: 15),
//                           Text(
//                             "$firstname $lastname",
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.brown.shade800,
//                             ),
//                           ),
//                           Text(
//                             designation,
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.brown.shade600,
//                             ),
//                           ),
//                           SizedBox(height: 15),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () {},
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.brown.shade500,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 10),
//                                 ),
//                                 child: Text(
//                                   'Month Info',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 15),
//                               ElevatedButton(
//                                 onPressed: () {},
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.brown.shade500,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 10),
//                                 ),
//                                 child: Text(
//                                   'Edit Profile',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Quick Actions',
//                     style: TextStyle(
//                       color: Colors.blueGrey.shade800,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black54,
//                           offset: Offset(1, 1),
//                           blurRadius: 3,
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 15),
//                   Container(
//                     height: 300, // Fixed height to constrain GridView
//                     child: Scrollbar(
//                       child: GridView.count(
//                         shrinkWrap: true,
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 15,
//                         mainAxisSpacing: 15,
//                         physics: AlwaysScrollableScrollPhysics(), // Enable scrolling
//                         children: [
//                           userCard(Icons.person, 'Profile', "/user_profile", context),
//                           userCard(Icons.calendar_month, 'Leave Application', "/user_leave", context),
//                           userCard(Icons.school, 'College', "", context),
//                           userCard(Icons.settings, 'Settings', "/settings", context),
//                           userCard(Icons.help, 'Help', "/user_help", context),
//                           userCard(Icons.groups, 'About Us', "/aboutus", context),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget userCard(IconData icon, String s, String routeName, BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (routeName.isNotEmpty) {
//           Navigator.pushNamed(context, routeName);
//         }
//       },
//       child: Card(
//         elevation: 6,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         color: Colors.brown.shade500,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: 40,
//               color: Colors.white,
//             ),
//             SizedBox(height: 10),
//             Text(
//               s,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {

  Timer? _locationCheckTimer;

  late final BackgroundLocationService backgroundLocationService;

  String firstname = "";
  String lastname = "";
  String designation = "";
  String department = "";
  bool isLoading = true;
  bool isLocationEnabled = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String userId;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    requestLocationPermission();
    _locationCheckTimer = Timer.periodic(Duration(seconds: 20), (timer) {
      checkLocationStatusAndNotify(context);
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid;
        backgroundLocationService = BackgroundLocationService();
        backgroundLocationService.initialize(userId);
      } else {
        print("User not logged in");
      }
    } catch (e) {
      print("Error initializing background location service: $e");
    }

  }

  @override
  void dispose() {
    _locationCheckTimer?.cancel();
    backgroundLocationService.stopLocationUpdates();
    super.dispose();
  }

  Future<void> checkLocationStatusAndNotify(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    setState(() {
      isLocationEnabled = serviceEnabled; // Update state
    });

    if (!serviceEnabled) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userId = user.uid;

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('student')
            .doc(userId)
            .get();

        final userName = userDoc['firstname'] ?? 'Unknown User';

        // Show local notification
        await LocalNotificationService.showNotification(
          "Location Off",
          "Your location is turned off. Please turn it back on.",
        );

        // Show alert dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Location Disabled"),
            content: Text("Please enable location services to continue."),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Geolocator.openLocationSettings();
                },
                child: Text("Open Settings"),
              ),
            ],
          ),
        );

        // Log to Realtime Database
        await NotificationLogger.logToFirebase(
          userId: userId,
          userName: userName,
          title: "Location Turned Off",
          message: "$userName has turned off location services.",
        );
      }
    }
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      // Show custom dialog
      bool accepted = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Location Permission"),
          content: Text("This app needs location access to function properly."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Deny")),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Allow")),
          ],
        ),
      );

      if (accepted) {
        status = await Permission.location.request();
        if (status.isGranted) {
          fetchAndStoreLocation();
        } else {
          showLocationAlert();
        }
      } else {
        showLocationAlert();
      }
    } else {
      fetchAndStoreLocation();
    }
  }


  Future<void> fetchAndStoreLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      final User? user = _auth.currentUser;
      if (user != null) {
        await FirestoreUtils.updateWithRetry(
          docRef: _firestore.collection('student').doc(user.uid),
          data: {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'lastUpdated': FieldValue.serverTimestamp(),
          },
        );
      }
    } catch (e) {
      print("Error getting or storing location: $e");
    }
  }

  void showLocationAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Location Disabled"),
        content: Text("Please enable location services to continue tracking."),
        actions: [
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
            },
            child: Text("Enable"),
          )
        ],
      ),
    );
  }

  Future<void> fetchUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('student')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          setState(() {
            firstname = snapshot.data()?['firstname'] ?? "Unknown";
            lastname = snapshot.data()?['lastname'] ?? "Unknown";
            designation = snapshot.data()?['designation'] ?? "Unknown";
            department = snapshot.data()?['department'] ?? "Unknown";
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signOut(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userId = currentUser.uid;

      // Fetch user name
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('student')
          .doc(userId)
          .get();
      final userName = userDoc['firstname'] ?? 'Unknown User';

      // Show local notification
      await LocalNotificationService.showNotification(
        "Logout",
        "You have been logged out.",
      );

      // Update status with retry
      await FirestoreUtils.updateWithRetry(
        docRef: FirebaseFirestore.instance.collection('student').doc(userId),
        data: {'status': 'Rejected'},
      );

      // Log to Realtime Database
      await NotificationLogger.logToFirebase(
        userId: userId,
        userName: userName,
        title: "User Logged Out",
        message: "$userName has logged out of the app.",
      );

      // Sign out
      await FirebaseAuth.instance.signOut();

      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/dit.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.brown.shade900.withOpacity(0.5), // Warm overlay
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.blueGrey.shade700))
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DIT Pimpri',
                        style: TextStyle(
                          color: Colors.blueGrey.shade800,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => signOut(context),
                        icon: Icon(Icons.logout, color: Colors.blueGrey.shade800),
                        iconSize: 28,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.brown.shade50, // Light beige card
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.brown.shade100,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.brown.shade800,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "$firstname $lastname",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown.shade800,
                            ),
                          ),
                          Text(
                            designation,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.brown.shade600,
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown.shade500,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                child: Text(
                                  'Month Info',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown.shade500,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.brown.shade50,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Tooltip(
                        message: isLocationEnabled
                            ? "Location services are active"
                            : "Tap to enable location services",
                        child: GestureDetector(
                          onTap: () async {
                            if (!isLocationEnabled) {
                              await Geolocator.openLocationSettings();
                            }
                          },
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Row(
                              key: ValueKey<bool>(isLocationEnabled),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isLocationEnabled ? Icons.location_on : Icons.location_off,
                                  color: isLocationEnabled ? Colors.green : Colors.red,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  isLocationEnabled ? "Location Enabled" : "Location Disabled",
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      color: Colors.blueGrey.shade800,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 300, // Fixed height to constrain GridView
                    child: Scrollbar(
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        physics: AlwaysScrollableScrollPhysics(), // Enable scrolling
                        children: [
                          userCard(Icons.person, 'Profile', "/user_profile", context),
                          userCard(Icons.calendar_month, 'Leave Application', "/user_leave", context),
                          userCard(Icons.school, 'College', "", context),
                          userCard(Icons.settings, 'Settings', "/settings", context),
                          userCard(Icons.help, 'Help', "/user_help", context),
                          userCard(Icons.groups, 'About Us', "/aboutus", context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget userCard(IconData icon, String s, String routeName, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (routeName.isNotEmpty) {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.brown.shade500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              s,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}