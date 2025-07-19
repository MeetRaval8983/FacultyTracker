import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter/material.dart';

class FacutlyInfoDescPage extends StatefulWidget {
  final String userId; // Pass userId to fetch details of a specific user
  const FacutlyInfoDescPage({Key? key, required this.userId}) : super(key: key);

  @override
  _FacutlyInfoDescPageState createState() => _FacutlyInfoDescPageState();
}

class _FacutlyInfoDescPageState extends State<FacutlyInfoDescPage> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('student')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          userDetails = userDoc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${userDetails?['firstname']} ${userDetails?['lastname']}',
          style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userDetails == null
          ? const Center(child: Text('No details found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: userDetails?['profileImage'] != null
                        ? NetworkImage(userDetails?['profileImage'])
                        : null,
                    child: userDetails?['profileImage'] == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Name: ${userDetails?['firstname']} ${userDetails?['lastname']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Email: ${userDetails?['email']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Mobile: ${userDetails?['mobile']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Username: ${userDetails?['username']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Department: ${userDetails?['department']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Designation: ${userDetails?['designation']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Status: ${userDetails?['status']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: userDetails?['status'] == 'Pending'
                        ? Colors.orange
                        : (userDetails?['status'] == 'Approved'
                        ? Colors.green
                        : Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
