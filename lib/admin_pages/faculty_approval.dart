import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facultytracker/admin_pages/faculty_approval_info.dart';

class FacultyApproval extends StatefulWidget {
  const FacultyApproval({super.key});

  @override
  State<FacultyApproval> createState() => _FacultyApprovalState();
}

class _FacultyApprovalState extends State<FacultyApproval> {

  String status = 'Pending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Approval',
        style: TextStyle(
            color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('student').where('status', isEqualTo: status.trim()).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if(!snapshot.hasData  || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No faculty appovals'),);
            }

            final facultyApprovals = snapshot.data!.docs;

            return ListView.builder(
              itemCount: facultyApprovals.length,
                itemBuilder: (context, index) {
                final data = facultyApprovals[index].data();
                final userId = facultyApprovals[index].id;

                return FacultyApprovalCard(
                    firstName: data['firstname'] ?? 'Unknown',
                    lastName: data['lastname'] ?? 'Unknown',
                    email: data['email'] ?? 'Unknown',
                    mobile: data['mobile'] ?? 'Unknown',
                    username: data['username'] ?? 'Unknown',
                    designation: data['designation'] ?? 'Unknown',
                    department: data['department'] ?? 'Unknown',
                    status: data['status'] ?? 'Unknown',
                    userId: userId
                );
                }
            );
          }
      ),
    );
  }
}


class FacultyApprovalCard extends StatelessWidget {

  final String firstName;
  final String lastName;
  final String designation;
  final String department;
  final String mobile;
  final String username;
  final String email;
  final String status;
  final String userId;

  const FacultyApprovalCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.username,
    required this.designation,
    required this.department,
    required this.status,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          // Navigator.pushNamed(context, '/faculty_approval_info', arguments: {userId: userId});
          Navigator.push(context, MaterialPageRoute(builder: (context) => FacultyApprovalInfoPage(userId: userId)));
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.indigo,
                      child: Icon(
                          Icons.account_circle,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$firstName $lastName',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.indigo
                          ),),
                          Text(designation),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: statusColor(status),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(status)
                    )
                  ],
                ),
                SizedBox(height: 10,),
                InfoRow(icon: Icons.email, label: 'Email', data: email),
                SizedBox(height: 10,),
                InfoRow(icon: Icons.phone, label: 'Mobile', data: mobile)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color statusColor(String status) {
  if(status == 'Pending') {
    return Colors.orange;
  } else if(status == 'Rejected') {
    return Colors.redAccent;
  } else {
    return Colors.greenAccent;
  }
}

class InfoRow extends StatelessWidget {

  final IconData icon;
  final String label;
  final String data;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Icon(icon,
          color: Colors.indigo,),
          SizedBox(width: 10,),
          Expanded(
              child: Text('$label: $data')
          )
        ],
    );
  }
}










// class FacultyApproval extends StatelessWidget {
//   const FacultyApproval({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pending Users'),
//         backgroundColor: Colors.indigo,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('student')
//             .where('status', isEqualTo: 'Pending') // Filter pending users
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No pending users.'));
//           }
//
//           final users = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: users.length,
//             itemBuilder: (context, index) {
//               final user = users[index];
//               final userId = user.id; // User document ID
//               final userData = user.data() as Map<String, dynamic>;
//
//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 elevation: 4,
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundImage: userData['profileImage'] != null
//                         ? NetworkImage(userData['profileImage'])
//                         : null,
//                     child: userData['profileImage'] == null
//                         ? const Icon(Icons.person)
//                         : null,
//                   ),
//                   title: Text('${userData['firstname']} ${userData['lastname']}'),
//                   subtitle: Text(userData['email']),
//                   trailing: const Icon(Icons.arrow_forward),
//                   onTap: () {
//                     // Navigate to the UserDetailsPage with the userId
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => UserDetailsPage(userId: userId),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
