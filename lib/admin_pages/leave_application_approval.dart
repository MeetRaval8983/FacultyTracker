import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter/material.dart';

class LeaveApplicationApproval extends StatefulWidget {
  final String userId; // Pass userId to fetch details of a specific user
  const LeaveApplicationApproval({Key? key, required this.userId}) : super(key: key);

  @override
  _LeaveApplicationApprovalState createState() => _LeaveApplicationApprovalState();
}

class _LeaveApplicationApprovalState extends State<LeaveApplicationApproval> {
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
          .collection('leaveApplication')
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

  Future<void> updateUserStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('leaveApplication')
          .doc(widget.userId)
          .update({'status': status});

      String emailBody = 'Dear faculty,\n\nYour leave application has been $status.';
      String emailSubject = 'Leave Application';
      String emailRecepient = userDetails?['email'];

      await sendEmail(emailRecepient, emailSubject, emailBody);

      // Fetch user email (assuming you store it in Firestore)
      // DocumentSnapshot userDoc = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(userId)
      //     .get();
      // String userEmail = userDoc['email'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User $status successfully')),
      );

      Navigator.pop(context); // Go back after status update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $e')),
      );
    }
  }

  Future<void> sendEmail(String recepient, String subject, String body) async {
    final Email email = Email(
        body: body,
        subject: subject,
        recipients: [recepient],
        isHTML: false
    );

    try {
      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email sent successfully'))
      );
    } catch(error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send email: $error'))
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
                  'Department: ${userDetails?['department']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Start Date: ${userDetails?['startDate']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'End Date: ${userDetails?['endDate']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Leave Type: ${userDetails?['leaveType']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Reason: ${userDetails?['reason']}',
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
                const SizedBox(height: 20),
                if (userDetails?['status'] == 'Pending')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => updateUserStatus('Approved'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Approve'),
                      ),
                      ElevatedButton(
                        onPressed: () => updateUserStatus('Rejected'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Reject'),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
