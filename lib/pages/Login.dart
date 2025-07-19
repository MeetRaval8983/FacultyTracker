import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facultytracker/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// class Login extends StatefulWidget {
//
//   @override
//   State<Login> createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   String? selectedDepartment;
//
//   final List<String> department = ['Civil Engineering', 'Mechanical Engineering', 'Electrical Engineering', 'Mechatronic Engineering', 'Computer Engineering', 'Information Technology', 'Polymer Engineering', 'Electronic & Telecommunication', 'Automobile Engineering'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//               // colors: [Colors.cyan[200]!, Colors.cyan[600]!],
//               // colors: [Colors.purple[300]!, Colors.red[300]!],
//               colors: [Colors.lightBlue[100]!, Colors.white],
//               // colors: [Colors.yellow[800]!, Colors.yellow[100]!],
//               // colors: [Colors.blue, Colors.yellow],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter
//           )
//         ),
//         padding: EdgeInsets.all(50),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Login',
//               style: TextStyle(
//                   color: Colors.blue,
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold
//               ),
//             ),
//             SizedBox(height: 30),
//             TextField(
//               decoration: InputDecoration(
//                   hintText: 'Enter username',
//                   prefixIcon: Icon(Icons.account_circle),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       borderSide: BorderSide(
//                         color: Colors.black,
//                         width: 2
//                       )
//                   )
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               obscureText: true,
//               obscuringCharacter: '*',
//               decoration: InputDecoration(
//                   hintText: 'Enter password',
//                   prefixIcon: Icon(Icons.lock),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       borderSide: BorderSide(
//                         color: Colors.black,
//                         width: 2
//                       )
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       borderSide: BorderSide(
//                           color: Colors.black,
//                           width: 2
//                       )
//                   )
//               ),
//             ),
//             SizedBox(height: 30),
//             Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: Colors.black ,
//                   width: 2
//                 )
//               ),
//               child: DropdownButton(
//                 value: selectedDepartment,
//                 hint: Text('Select department'),
//                 items: department.map((String item) {
//                   return DropdownMenuItem(
//                     value: item,
//                     child: Text(item),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedDepartment = newValue;
//                   });
//                 },
//                 icon: Icon(Icons.arrow_drop_down),
//                 style: TextStyle(color: Colors.blue, fontSize: 18),
//                 dropdownColor: Colors.white,
//                 isExpanded: true,
//               ),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40)
//                 ),
//                 onPressed: () {},
//                 child: Text(
//                     'Login',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold
//                     ))
//             ),
//             SizedBox(height: 10),
//             InkWell(
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
//               },
//               child: Text(
//                 'Don\'t have an account? Sign up',
//                 style: TextStyle(
//                     color: Colors.blue[900],
//                     decoration: TextDecoration.underline
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }





// The issue arises because you're querying Firestore using multiple where clauses (username, password, and department) and Firestore handles each where clause as an AND operation, but it's not atomic for all fields.
// If username and department match, Firestore returns the document, even if the password does not match.
// Firestore queries are not guaranteed to compare all fields simultaneously in the way you might expect (like SQL). If username and department match, Firestore will still return the document, even if the password doesn't match the stored value.
// This is because the password field is being checked in isolation.






class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? selectedDepartment;

  final List<String> department = [
    'Civil Engineering',
    'Mechanical Engineering',
    'Electrical Engineering',
    'Mechatronic Engineering',
    'Computer Engineering',
    'Information Technology',
    'Polymer Engineering',
    'Electronic & Telecommunication',
    'Automobile Engineering',
  ];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  Future<void> signInWithEmail() async {
    try {

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
      );

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('student')
          .where('email', isEqualTo: emailController.text.trim())
          .where('password', isEqualTo: passwordController.text.trim())
          .get();

      if(querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        if(userData != null && userData['status'] != null) {
          if(userData['status'] == 'Pending') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Cannot sign in until Admin approves'))
            );
            return;
          } else if(userData['status'] == 'Rejected') {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid user register again'))
            );
            return;
          } else {
            Navigator.pushReplacementNamed(context, '/user_home');
            print('Sign in successful');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign in successful')),
            );
          }
        }
      }

      // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      // await sharedPreferences.setBool('isLoggedIn', true);
      // await sharedPreferences.setBool('isAdmin', false);

      // Navigator.pushReplacementNamed(context, '/user_home');
      // print('Sign in successful');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Sign in successful')),
      // );
    } catch(e) {
      print('Sign in failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed')),
      );
    }
  }

  Future<void> signInWithUsername() async {
    try {
      if (selectedDepartment == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select a department'),
        ));
        return;
      }

      print("Querying Firestore with:");
      print("Username: ${usernameController.text.trim()}");
      print("Password: ${passwordController.text.trim()}");
      print("Department: $selectedDepartment");

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('student')
          .where('username', isEqualTo: usernameController.text.trim())
          .where('password', isEqualTo: passwordController.text.trim())
          // .where('department', isEqualTo: selectedDepartment)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        if (userData != null && userData['username'] != null) {
          if(userData['department'] == selectedDepartment) {
            print("Signed in as: ${userData['username']}");
            Navigator.pushReplacementNamed(context, '/user_home');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Signed in as ${userData['username']}'),
            ));
          } else {
            print("Invalid department");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Invalid department'),
            ));
          }
        } else {
          print("Username not found in the document");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Username not found in the document'),
          ));
        }
      } else {
        print("No user found with these credentials");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No user found with these credentials'),
        ));
      }
    } catch (e) {
      print("Sign-in failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign-in failed: $e'),
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
                colors: [Colors.blue[700]!, Colors.blue[300]!],
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
                      Icons.school,
                      color: Colors.blue[700],
                      size: 50,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Login Header
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Login to continue',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 30),
                  // Username Input
                  TextField(
                    controller: emailController,
                    // controller: usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter username',
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
                  // SizedBox(height: 20),
                  // Department Dropdown
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 15),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(30),
                  //   ),
                  //   child: DropdownButton<String>(
                  //     value: selectedDepartment,
                  //     hint: Text('Select department'),
                  //     isExpanded: true,
                  //     underline: SizedBox(),
                  //     icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  //     items: department.map((String item) {
                  //       return DropdownMenuItem(
                  //         value: item,
                  //         child: Text(item),
                  //       );
                  //     }).toList(),
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         selectedDepartment = newValue;
                  //       });
                  //     },
                  //   ),
                  // ),
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
                  SizedBox(height: 20),
                  // Sign Up Option
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text(
                      'Don\'t have an account? Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
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
