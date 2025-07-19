import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserHelpPage extends StatefulWidget {
  @override
  _UserHelpPageState createState() => _UserHelpPageState();
}

class _UserHelpPageState extends State<UserHelpPage> {

  String? username;
  String? email;
  String? mobile;
  String? firstname;
  String? lastname;

  String? fileName;
  File? file;

  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  Future<void> pickFile() async {
    print('welcome');
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    print("hello world");
    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
        fileName = result.files.single.name;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
    }
  }
  // Fetch user details from Firestore
  Future<void> getUserDetails() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('student') // Assuming your user details are stored in 'users' collection
            .doc(currentUser.uid) // Using the current user's UID to fetch their details
            .get();

        if (userDoc.exists) {
          setState(() {
            username = userDoc['username'];
            email = currentUser.email;
            mobile = userDoc['mobile'];
            firstname = userDoc['firstname'];
            lastname = userDoc['lastname'];
          });
        }
        print(username);
        print(email);
        print(mobile);
        print(firstname);
        print(lastname);
      } catch (e) {
        print("Error fetching user details: $e");
      }
    }
  }

  Future<void> submitForm() async {
    if (subjectController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        username == null ||
        email == null ||
        mobile == null ||
        firstname == null ||
        lastname == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all the fields')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    String? fileUrl;
    if (file != null) {
      try {
        String filePath =
            'user_help_files/${DateTime.now().millisecondsSinceEpoch}_$fileName';
        print('File path: $filePath');
        UploadTask uploadTask =
            FirebaseStorage.instance.ref(filePath).putFile(file!);
        TaskSnapshot snapshot = await uploadTask;
        fileUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        print('File upload failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File upload failed: $e')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }
    }
    try {
      await FirebaseFirestore.instance.collection('userHelp').add({
        'subject': subjectController.text,
        'description': descriptionController.text,
        'fileUrl': fileUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'username': username,
        'email': email,
        'mobile': mobile,
        'firstname': firstname,
        'lastname': lastname,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Help request submitted successfully.')),
      );

      // Clear fields after submission
      subjectController.clear();
      descriptionController.clear();
      setState(() {
        file = null;
        fileName = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $e')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'User Help',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject Text Field
              Text(
                'Subject:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  hintText: 'Enter subject',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Description Text Field
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter detailed description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              // SizedBox(height: 20),
              //
              // // Attach File Button
              // Row(
              //   children: [
              //     ElevatedButton(
              //       // onPressed: _pickFile,
              //       onPressed: pickFile,
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.greenAccent,
              //         padding:
              //             EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //       ),
              //       child: Text('Attach File'),
              //     ),
              //     SizedBox(width: 20),
              //     if (fileName != null)
              //       Text(
              //         fileName!,
              //         style: TextStyle(fontSize: 16, color: Colors.black54),
              //       ),
              //   ],
              // ),
              SizedBox(height: 30),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Submit',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
