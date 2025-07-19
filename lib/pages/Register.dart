import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class Register extends StatefulWidget {
//
//   @override
//   State<Register> createState() => _RegisterState();
// }
//
// List<String> gender = ['Male','Female'];
// final List<String> department = [
//   'Civil Engineering',
//   'Mechanical Engineering',
//   'Electrical Engineering',
//   'Mechatronic Engineering',
//   'Computer Engineering',
//   'Information Technology',
//   'Polymer Engineering',
//   'Electronic & Telecommunication',
//   'Automobile Engineering',
// ];
//
// class _RegisterState extends State<Register> {
//
//   String? selectedDepartment;
//   String? selectedGender = gender[0];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 // colors: [Colors.lightBlueAccent[100]!,Colors.lightBlue[100]!,Colors.lightBlueAccent[100]!],
//                 colors: [Colors.lightBlue[100]!, Colors.lightBlue[200]!, Colors.lightBlue[100]!],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter
//             )
//           ),
//           child: Padding  (
//             padding: const EdgeInsets.all(18.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                       'Register to DIT',
//                     style: TextStyle(
//                       color: Colors.blueAccent,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.person),
//                       hintText: 'First Name',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20)
//                       )
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.person),
//                         hintText: 'Last Name',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20)
//                         )
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.account_circle),
//                         hintText: 'Username',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20)
//                         )
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                       'Gender',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                       color: Colors.blueAccent
//                     ),),
//                   ListTile(
//                     title: Text('Male'),
//                     leading: Radio(
//                         value: gender[0],
//                         groupValue: selectedGender,
//                         onChanged: (String? v) {
//                           setState(() {
//                             selectedGender = v;
//                           });
//                         }
//                     ),
//                   ),
//                   ListTile(
//                     title: Text('Female'),
//                     leading: Radio(
//                         value: gender[1],
//                         groupValue: selectedGender,
//                         onChanged: (String? v) {
//                           setState(() {
//                             selectedGender = v;
//                           });
//                         }
//                     ),
//                   ),
//                   // Padding(
//                   //   padding: const EdgeInsets.all(16.0),
//                   //   child: Text('Selected Option: $selectedGender'),
//                   // ),
//                   SizedBox(height: 20),
//                   TextField(
//                     decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.lock),
//                         hintText: 'Last Password',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20)
//                         )
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.lock),
//                         hintText: 'Confirm Password',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20)
//                         )
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                     padding: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                         color: Colors.black,
//                       ),
//                     ),
//                     child: DropdownButton(
//                         hint: Text('Select department'),
//                         value: selectedDepartment,
//                         isExpanded: true, // for full width
//                         items: department.map((String item) {
//                           return DropdownMenuItem(
//                               value: item,
//                               child: Text(item)
//                           );
//                         }).toList(),
//                         onChanged: (String? d) {
//                           setState(() {
//                             selectedDepartment = d;
//                           });
//                         }
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.school),
//                         hintText: 'Designation',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20)
//                         )
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.phone),
//                         hintText: 'Mobile Number',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20)
//                         )
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.email),
//                         hintText: 'Email address',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20)
//                         )
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue[600],
//                         minimumSize: Size(double.infinity, 50)
//                       ),
//                       child: Text(
//                           'Register',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold
//                         ),
//                       ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }










// class Register extends StatefulWidget {
//   @override
//   State<Register> createState() => _RegisterState();
// }
//
// List<String> gender = ['Male', 'Female'];
// final List<String> department = [
//   'Civil Engineering',
//   'Mechanical Engineering',
//   'Electrical Engineering',
//   'Mechatronic Engineering',
//   'Computer Engineering',
//   'Information Technology',
//   'Polymer Engineering',
//   'Electronic & Telecommunication',
//   'Automobile Engineering',
// ];
//
// class _RegisterState extends State<Register> {
//   String? selectedDepartment;
//   String? selectedGender = gender[0];
//
//   final TextEditingController firstnameController = TextEditingController();
//   final TextEditingController lastnameController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController designationController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//
//   // Firebase instances
//   final FirebaseAuth fire_auth = FirebaseAuth.instance;
//   final FirebaseFirestore fire_store = FirebaseFirestore.instance;
//
//   // Function to handle sign-up
//   Future<void> signUp() async {
//     final String firstname = firstnameController.text.trim();
//     final String lastname = lastnameController.text.trim();
//     final String username = usernameController.text.trim();
//     final String password = passwordController.text.trim();
//     final String designation = designationController.text.trim();
//     final String mobile = mobileController.text.trim();
//     final String email = emailController.text.trim();
//
//     if(firstname.isEmpty ||
//         lastname.isEmpty ||
//         username.isEmpty ||
//         password.isEmpty ||
//         designation.isEmpty ||
//         mobile.isEmpty ||
//         email.isEmpty ||
//         selectedGender == null ||
//         selectedDepartment == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please fill all the fields')),
//       );
//       return;
//     }
//
//     try {
//       // Create user in Firebase Authentication
//       UserCredential userCredential = await fire_auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password
//       );
//
//       String uid = userCredential.user!.uid; // Get unique user ID
//
//       // Store additional user data in Firestore
//       await fire_store.collection('student').doc(uid).set({
//         'firstname': firstname,
//         'lastname': lastname,
//         'username': username,
//         'gender': selectedGender,
//         'department': selectedDepartment,
//         'designation': designation,
//         'mobile': mobile,
//         'email': email,
//         'password': password,
//         'status': "Pending"
//       });
//       Navigator.pushReplacementNamed(context, '/home');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Sign-Up successful')),
//       );
//
//     } catch(e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.lightBlue.shade100, Colors.blue.shade300],
//               // colors: [Colors.indigo[100]!, Colors.bxlue],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       'Register to DIT',
//                       style: TextStyle(
//                         color: Colors.blueAccent,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 32,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   buildTextField(firstnameController, 'First Name', Icons.person),
//                   SizedBox(height: 20),
//                   buildTextField(lastnameController, 'Last Name', Icons.person),
//                   SizedBox(height: 20),
//                   buildTextField(usernameController, 'Username', Icons.account_circle),
//                   SizedBox(height: 20),
//                   Text(
//                     'Gender',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.blueAccent,
//                     ),
//                   ),
//                   Column(
//                     children: gender.map((String g) {
//                       return RadioListTile(
//                         title: Text(g),
//                         value: g,
//                         groupValue: selectedGender,
//                         onChanged: (String? value) {
//                           setState(() {
//                             selectedGender = value;
//                           });
//                         },
//                       );
//                     }).toList(),
//                   ),
//                   SizedBox(height: 20),
//                   buildTextField(passwordController, 'Password', Icons.lock, obscureText: true),
//                   SizedBox(height: 20),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.blueAccent),
//                     ),
//                     child: DropdownButton<String>(
//                       hint: Text('Select Department'),
//                       value: selectedDepartment,
//                       isExpanded: true,
//                       items: department.map((String item) {
//                         return DropdownMenuItem(
//                           value: item,
//                           child: Text(item),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedDepartment = newValue;
//                         });
//                       },
//                       underline: SizedBox(),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   buildTextField(designationController, 'Designation', Icons.school),
//                   SizedBox(height: 20),
//                   buildTextField(mobileController, 'Mobile Number', Icons.phone,),
//                   SizedBox(height: 20),
//                   buildTextField(emailController, 'Email Address', Icons.email),
//                   SizedBox(height: 30),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         await signUp();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                       ),
//                       child: Text(
//                         'Register',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
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
//   Widget buildTextField(TextEditingController c, String hint, IconData icon, {bool obscureText = false}) {
//     return TextField(
//       controller: c,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.blueAccent),
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

List<String> gender = ['Male', 'Female'];
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

class _RegisterState extends State<Register> {
  String? selectedDepartment;
  String? selectedGender = gender[0];

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FirebaseAuth fire_auth = FirebaseAuth.instance;
  final FirebaseFirestore fire_store = FirebaseFirestore.instance;

  Future<void> signUp() async {
    final String firstname = firstnameController.text.trim();
    final String lastname = lastnameController.text.trim();
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();
    final String designation = designationController.text.trim();
    final String mobile = mobileController.text.trim();
    final String email = emailController.text.trim();

    if (firstname.isEmpty ||
        lastname.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        designation.isEmpty ||
        mobile.isEmpty ||
        email.isEmpty ||
        selectedGender == null ||
        selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    try {
      UserCredential userCredential = await fire_auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await fire_store.collection('student').doc(uid).set({
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'gender': selectedGender,
        'department': selectedDepartment,
        'designation': designation,
        'mobile': mobile,
        'email': email,
        'password': password,
        'status': 'Pending',
      });
      Navigator.pushReplacementNamed(context, '/home');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-Up successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
              Colors.brown.shade900.withOpacity(0.5), // Warm overlay to match building
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'Register to DIT',
                      style: TextStyle(
                        color: Colors.blueGrey.shade800, // Dark blue shade for title
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(2, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade100, // Light beige to match building tones
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.brown.shade200.withOpacity(0.7),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.15),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextField(firstnameController, 'First Name', Icons.person),
                          SizedBox(height: 20),
                          buildTextField(lastnameController, 'Last Name', Icons.person),
                          SizedBox(height: 20),
                          buildTextField(usernameController, 'Username', Icons.account_circle),
                          SizedBox(height: 20),
                          Text(
                            'Gender',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.brown.shade800, // Darker brown for label
                            ),
                          ),
                          Column(
                            children: gender.map((String g) {
                              return RadioListTile(
                                title: Text(g, style: TextStyle(color: Colors.brown.shade800)),
                                value: g,
                                groupValue: selectedGender,
                                activeColor: Colors.blueGrey.shade600,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 20),
                          buildTextField(passwordController, 'Password', Icons.lock, obscureText: true),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.brown.shade300),
                            ),
                            child: DropdownButton<String>(
                              hint: Text('Select Department', style: TextStyle(color: Colors.brown.shade600)),
                              value: selectedDepartment,
                              isExpanded: true,
                              dropdownColor: Colors.brown.shade50,
                              style: TextStyle(color: Colors.brown.shade800),
                              items: department.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDepartment = newValue;
                                });
                              },
                              underline: SizedBox(),
                            ),
                          ),
                          SizedBox(height: 20),
                          buildTextField(designationController, 'Designation', Icons.school),
                          SizedBox(height: 20),
                          buildTextField(mobileController, 'Mobile Number', Icons.phone),
                          SizedBox(height: 20),
                          buildTextField(emailController, 'Email Address', Icons.email),
                          SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              onPressed: signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController c, String hint, IconData icon, {bool obscureText = false}) {
    return TextField(
      controller: c,
      obscureText: obscureText,
      style: TextStyle(color: Colors.brown.shade800),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.brown.shade600),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.brown.shade500),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}