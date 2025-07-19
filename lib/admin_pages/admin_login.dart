import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  @override
  State<AdminLogin> createState() => _AdminState();
}

class _AdminState extends State<AdminLogin> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmail() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      // await sharedPreferences.setBool('isLoggedIn', true);
      // await sharedPreferences.setBool('isAdmin', true);
      Navigator.pushReplacementNamed(context, '/admin_home');
      print('Admin login successful');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in successful')),
      );
    } catch(e) {
      print('Admin login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin login failed')),
      );
    }
  }

  Future<void> signInWithUsername() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('adminlogin')
          // .where('email', isEqualTo: emailController.text.trim())
          .where('username', isEqualTo: usernameController.text.trim())
          .where('password', isEqualTo: passwordController.text.trim())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        if (userData != null && userData['username'] != null) {
            print("Admin Login successful");

            final doc = querySnapshot.docs.first;
            Navigator.pushReplacementNamed(context, '/admin_home', arguments: {
              'uid': doc.id, // Pass the document ID
              'firstname': doc['firstname'],
              'lastname': doc['lastname'],
              'designation': doc['designation'],
            });

            // Navigator.pushNamed(context, '/admin_home');

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Admin login successful'),
            ));
        } else {
          print("Admin not found");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Admin not found'),
          ));
        }
      } else {
        print("Incorrect Admin credentials");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Incorrect Admin credentials'),
        ));
      }
    } catch (e) {
      print("Admin Login failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Admin Login failed: $e'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[800]!, Colors.redAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: Colors.blue[700],
                      size: 50,
                    ),
                  ),
                  SizedBox(height: 40),
                  // Login Header
                  Text(
                    'Admin Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                  // Username Input
                  TextField(
                    controller: emailController,
                    // controller: usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter email',
                      prefixIcon: Icon(Icons.account_circle, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Password Input
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter password',
                      prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: signInWithEmail,
                    // onPressed: signInWithUsername,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}