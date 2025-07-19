import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminHelpPage extends StatelessWidget {
  const AdminHelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Help Requests',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('userHelp').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Help Requests Available',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            );
          }

          final helpRequests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: helpRequests.length,
            itemBuilder: (context, index) {
              final data = helpRequests[index].data();
              return HelpRequestCard(
                firstname: data['firstname'] ?? 'Unknown',
                lastname: data['lastname'] ?? 'Unknown',
                subject: data['subject'] ?? 'No subject provided',
                description: data['description'] ?? 'No description provided',
                timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
              );
            },
          );
        },
      ),
    );
  }
}

class HelpRequestCard extends StatelessWidget {
  final String firstname;
  final String lastname;
  final String subject;
  final String description;
  final DateTime timestamp;

  const HelpRequestCard({
    Key? key,
    required this.firstname,
    required this.lastname,
    required this.subject,
    required this.description,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    '$firstname $lastname',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            InfoRow(icon: Icons.subject, label: 'Subject', value: subject),
            const SizedBox(height: 10),
            InfoRow(icon: Icons.description, label: 'Description', value: description),
            const SizedBox(height: 10),
            InfoRow(
              icon: Icons.calendar_today,
              label: 'Submitted On',
              value: '${timestamp.day}/${timestamp.month}/${timestamp.year}',
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.indigo, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "$label: $value",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
