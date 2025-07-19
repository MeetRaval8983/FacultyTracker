import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facultytracker/admin_pages/facutly_info_desc.dart';

class FacultyInfoPage extends StatefulWidget {
  const FacultyInfoPage({super.key});

  @override
  State<FacultyInfoPage> createState() => _FacultyInfoPageState();
}

class _FacultyInfoPageState extends State<FacultyInfoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Information',
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore.collection('student').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No Faculty Data Available',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              );
            }

            final facultyData = snapshot.data!.docs;

            return ListView.builder(
              itemCount: facultyData.length,
              itemBuilder: (context, index) {
                final data = facultyData[index].data();
                final userId = facultyData[index].id;
                return FacultyCard(
                  firstname: "${data['firstname'] ?? 'N/A'}",
                  lastname: "${data['lastname'] ?? 'N/A'}",
                  designation: "${data['designation'] ?? 'N/A'}",
                  department: "${data['department'] ?? 'N/A'}",
                  mobile: "${data['mobile'] ?? 'N/A'}",
                  email: "${data['email'] ?? 'N/A'}",
                  userId: userId,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class FacultyCard extends StatelessWidget {
  final String firstname;
  final String lastname;
  final String designation;
  final String department;
  final String mobile;
  final String email;
  final String userId;

  const FacultyCard(
      {Key? key,
      required this.firstname,
      required this.lastname,
      required this.designation,
      required this.department,
      required this.mobile,
      required this.email,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FacutlyInfoDescPage(userId: userId)));
        },
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$firstname $lastname',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          Text(
                            designation,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                InfoRow(
                    icon: Icons.business,
                    label: 'Department',
                    value: department),
                const SizedBox(height: 10),
                InfoRow(icon: Icons.phone, label: 'Mobile', value: mobile),
                const SizedBox(height: 10),
                InfoRow(icon: Icons.email, label: 'Email', value: email),
              ],
            ),
          ),
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
