import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String firstname = "";
  String lastname = "";
  String designation = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   // Retrieve arguments passed to this route
  //   final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  //
  //   if (args != null) {
  //     fetchUserData(args['uid']);
  //   }
  // }

  // use when sign in with email
  Future<void> fetchUserData() async {
    try {
      print("hi");
      final User? user = FirebaseAuth.instance.currentUser;
      print("Current User UID: ${user?.uid}");
      print("hello");

      if (user != null) {
        print("Current User UID: ${user?.uid}");
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('adminlogin')
                .doc(user.uid)
                .get();

        if (snapshot.exists) {
          print("Firestore Document Data: ${snapshot.data()}");
          setState(() {
            firstname = snapshot.data()?['firstname'] ?? "Unknown";
            lastname = snapshot.data()?['lastname'] ?? "Unknown";
            designation = snapshot.data()?['designation'] ?? "Unknown";
            designation = snapshot.data()?['designation'] ?? "Unknown";
            isLoading = false;
          });
        } else {
          print("No document found for UID: ${user.uid}");
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

  // use for sign in with username
  // Future<void> fetchUserData(String uid) async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance.collection('adminlogin').doc(uid).get();
  //
  //     if (snapshot.exists) {
  //       setState(() {
  //         firstname = snapshot['firstname'] ?? "Unknown";
  //         lastname = snapshot['lastname'] ?? "Unknown";
  //         designation = snapshot['designation'] ?? "Unknown";
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching user data: $e");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> signOut(BuildContext context) async {

    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // await sharedPreferences.clear();

    // using streambuilder by fetching data from firebase
    try {
      await FirebaseAuth.instance.signOut();
      // Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print('Admin sign out failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin sign out failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DIT Pimpri',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () async {
                signOut(context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.blue,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient:
                          LinearGradient(
                            // colors: [Colors.blue[900]!, Colors.blue[600]!, Colors.blue[300]!],
                              colors: [Colors.blue[800]!, Colors.redAccent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter
                          ),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            // backgroundImage: AssetImage('assets/jayhong.png'),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "$firstname $lastname",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            designation,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                child: Text(
                                  'Month Info',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: [
                          userCard(Icons.info, 'Student Info', "/faculty_info",
                              context),
                          userCard(Icons.info, 'Student Approval', "/faculty_approval",
                              context),
                          userCard(Icons.calendar_month, 'Leave application',
                              "/leave_applications", context),
                          userCard(Icons.map, 'Map', "/map_page", context),
                          userCard(Icons.settings, 'Settings', "", context),
                          userCard(Icons.help, 'Help', "/admin_help", context),
                          userCard(Icons.groups, 'About Us', "/aboutus", context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Widget userCard(
    IconData icon, String s, String routeName, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, routeName);
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(
                    // colors: [Colors.blue[900]!, Colors.blue[600]!, Colors.blue[300]!],
                    colors: [Colors.blue[800]!, Colors.redAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                ),
          borderRadius: BorderRadius.circular(15)
        ),
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
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    ),
  );
}
