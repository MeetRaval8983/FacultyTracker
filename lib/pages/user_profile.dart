import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstname = "";
  String lastname = "";
  String email = "";
  String mobile = "";
  String department = "";
  String designation = "";
  String username = "";
  String profileImageUrl = "";
  bool isLoading = true;

  Future<void> fetchUserDetails() async {
    try {
      final User? user = await FirebaseAuth.instance.currentUser;

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
            email = snapshot.data()?['email'] ?? "Unknown";
            mobile = snapshot.data()?['mobile'] ?? "Unknown";
            department = snapshot.data()?['department'] ?? "Unknown";
            designation = snapshot.data()?['designation'] ?? "Unknown";
            username = snapshot.data()?['username'] ?? "Unknown";
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching details: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error fetching details: $e")));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.indigo, Colors.blue],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter
                          ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 10),
                            Center(
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    AssetImage('assets/jayhong.png'),
                                backgroundColor: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '$firstname $lastname',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              designation,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            profileCard(Icons.email, 'Email', email),
                            const Divider(),
                            profileCard(Icons.phone, 'Mobile', mobile),
                            const Divider(),
                            profileCard(Icons.person, 'Username', username),
                            const Divider(),
                            profileCard(Icons.work, 'Designation', designation),
                            const Divider(),
                            profileCard(Icons.school, 'Department', department),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.indigo),
                      title: Text('Privacy Settings'),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.help, color: Colors.indigo),
                      title: Text('Help & Support'),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.indigo),
                      title: Text('Logout'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

Widget profileCard(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black87,
            size: 15,
          ),
          SizedBox(width: 10),
      Text(
          "$label:",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ],
      ),
    ),
  );
}








// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   String firstname = "";
//   String lastname = "";
//   String email = "";
//   String mobile = "";
//   String department = "";
//   String designation = "";
//   String username = "";
//   String profileImageUrl = "";
//   bool isLoading = true;
//
//   Future<void> fetchUserDetails() async {
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
//             email = snapshot.data()?['email'] ?? "Unknown";
//             mobile = snapshot.data()?['mobile'] ?? "Unknown";
//             department = snapshot.data()?['department'] ?? "Unknown";
//             designation = snapshot.data()?['designation'] ?? "Unknown";
//             username = snapshot.data()?['username'] ?? "Unknown";
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       print("Error fetching details: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error fetching details: $e")));
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserDetails();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Profile',
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//         backgroundColor: Colors.indigo,
//         elevation: 4,
//       ),
//       body: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(),
//       )
//           : SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // Profile Header
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     height: 180,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.indigo, Colors.blueAccent],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       const CircleAvatar(
//                         radius: 60,
//                         backgroundImage: AssetImage('assets/jayhong.png'),
//                         backgroundColor: Colors.white,
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         '$firstname $lastname',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         designation,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // Profile Details
//               Card(
//                 elevation: 4,
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     children: [
//                       profileDetail(Icons.person, "Username", username),
//                       const Divider(),
//                       profileDetail(Icons.email, "Email", email),
//                       const Divider(),
//                       profileDetail(Icons.phone, "Mobile", mobile),
//                       const Divider(),
//                       profileDetail(Icons.school, "Department", department),
//                       const Divider(),
//                       profileDetail(Icons.work, "Designation", designation),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Additional Options
//               buildOption(Icons.settings, "Privacy Settings"),
//               const Divider(),
//               buildOption(Icons.help, "Help & Support"),
//               const Divider(),
//               buildOption(Icons.logout, "Logout"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget profileDetail(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.indigo),
//         const SizedBox(width: 15),
//         Text(
//           "$label:",
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.black54,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(fontSize: 16, color: Colors.black87),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget buildOption(IconData icon, String title) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.indigo),
//       title: Text(
//         title,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//       onTap: () {
//         // Handle option tap here
//       },
//     );
//   }
// }

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   String firstname = "";
//   String lastname = "";
//   String email = "";
//   String phone = "";
//   String profileImageUrl = "";
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }
//
//   Future<void> fetchUserData() async {
//     try {
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
//             .collection('student')
//             .doc(user.uid)
//             .get();
//
//         if (snapshot.exists) {
//           setState(() {
//             firstname = snapshot.data()?['firstname'] ?? "Unknown";
//             lastname = snapshot.data()?['lastname'] ?? "Unknown";
//             email = snapshot.data()?['email'] ?? "Unknown";
//             phone = snapshot.data()?['mobile'] ?? "Unknown";
//             profileImageUrl = snapshot.data()?['profileImageUrl'] ?? "";
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Profile",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.indigo,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               // Profile Picture
//               Center(
//                 child: CircleAvatar(
//                   radius: 70,
//                   backgroundImage: profileImageUrl.isNotEmpty
//                       ? NetworkImage(profileImageUrl)
//                       : const AssetImage("assets/default_profile.png")
//                   as ImageProvider,
//                   backgroundColor: Colors.grey.shade300,
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Name
//               Text(
//                 '$firstname $lastname',
//                 style: const TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//
//               // Email
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.email, color: Colors.indigo),
//                   const SizedBox(width: 10),
//                   Text(
//                     email,
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//
//               // Phone
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.phone, color: Colors.indigo),
//                   const SizedBox(width: 10),
//                   Text(
//                     phone,
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
//
//               // Edit Profile Button
//               ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/edit_profile');
//                 },
//                 icon: const Icon(Icons.edit),
//                 label: const Text("Edit Profile"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.indigo,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 15, horizontal: 30),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Additional Options
//               ListTile(
//                 leading: const Icon(Icons.security, color: Colors.indigo),
//                 title: const Text("Privacy Settings"),
//                 onTap: () {
//                   // Handle privacy settings navigation
//                 },
//               ),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(Icons.help, color: Colors.indigo),
//                 title: const Text("Help & Support"),
//                 onTap: () {
//                   // Handle help and support navigation
//                 },
//               ),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(Icons.logout, color: Colors.red),
//                 title: const Text("Logout"),
//                 onTap: () async {
//                   await FirebaseAuth.instance.signOut();
//                   Navigator.pushReplacementNamed(context, '/login');
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   String name = "";
//   String email = "";
//   String mobile = "";
//   String designation = "";
//   String department = "";
//   String username = "";
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProfileData();
//   }
//
//   Future<void> fetchProfileData() async {
//     try {
//       // Replace 'yourUserId' with actual user ID logic
//       // final String userId = "yourUserId";
//
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         final DocumentSnapshot<
//             Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
//             .collection('student')
//             .doc(user.uid)
//             .get();
//
//         // final DocumentSnapshot<Map<String, dynamic>> snapshot =
//         // await FirebaseFirestore.instance.collection('student').doc(userId).get();
//
//         if (snapshot.exists) {
//           setState(() {
//             name = snapshot.data()?['name'] ?? "Unknown";
//             email = snapshot.data()?['email'] ?? "Unknown";
//             mobile = snapshot.data()?['mobile'] ?? "Unknown";
//             designation = snapshot.data()?['designation'] ?? "Unknown";
//             department = snapshot.data()?['department'] ?? "Unknown";
//             username = snapshot.data()?['username'] ?? "Unknown";
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       print("Error fetching profile data: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Profile',
//           style: TextStyle(color: Colors.white, fontSize: 22),
//         ),
//         backgroundColor: Colors.indigo,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // Profile Header
//               Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     children: [
//                       const CircleAvatar(
//                         radius: 50,
//                         backgroundImage: AssetImage('assets/profile.png'), // Replace with actual profile image
//                       ),
//                       const SizedBox(height: 15),
//                       Text(
//                         name,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.indigo,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         designation,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontStyle: FontStyle.italic,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Profile Details
//               Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       buildProfileDetailRow(Icons.person, "Username", username),
//                       buildProfileDetailRow(Icons.email, "Email", email),
//                       buildProfileDetailRow(Icons.phone, "Mobile", mobile),
//                       buildProfileDetailRow(Icons.work, "Designation", designation),
//                       buildProfileDetailRow(Icons.school, "Department", department),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildProfileDetailRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.indigo),
//           const SizedBox(width: 10),
//           Text(
//             "$label:",
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 16, color: Colors.black87),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
