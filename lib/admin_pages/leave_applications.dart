import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facultytracker/admin_pages/leave_application_approval.dart';
import 'package:flutter/material.dart';

class LeaveApplicationsPage extends StatelessWidget {
  const LeaveApplicationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leave Applications',
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
        stream: FirebaseFirestore.instance.collection('leaveApplication').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Leave Applications Available',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            );
          }

          final leaveApplications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: leaveApplications.length,
            itemBuilder: (context, index) {
              final data = leaveApplications[index].data();
              final userId = leaveApplications[index].id;

              return LeaveApplicationCard(
                firstname: data['firstname'] ?? 'Unknown',
                lastname: data['lastname'] ?? 'Unknown',
                email: data['email'] ?? 'Unknown',
                leaveType: data['leaveType'] ?? 'Unknown',
                mobile: data['mobile'] ?? 'Unknown',
                department: data['department'] ?? 'Unknown',
                reason: data['reason'] ?? 'No reason provided',
                startDate: data['startDate'] ?? 'Unknown',
                endDate: data['endDate'] ?? 'Unknown',
                status: data['status'] ?? 'Pending',
                userId: userId,
              );
            },
          );
        },
      ),
    );
  }
}

class LeaveApplicationCard extends StatelessWidget {

  final String firstname;
  final String lastname;
  final String department;
  final String email;
  final String leaveType;
  final String mobile;
  final String reason;
  final String startDate;
  final String endDate;
  final String status;
  final String userId;

  const LeaveApplicationCard({
    Key? key,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.leaveType,
    required this.mobile,
    required this.department,
    required this.reason,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.userId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => LeaveApplicationApproval(userId: userId))
        );
      },
      child: Card(
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
                          department,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor(status),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              InfoRow(icon: Icons.calendar_today, label: 'Start Date', value: startDate),
              const SizedBox(height: 10),
              InfoRow(icon: Icons.calendar_today_outlined, label: 'End Date', value: endDate),
              const SizedBox(height: 10),
              InfoRow(icon: Icons.edit_note, label: 'Reason', value: reason),
            ],
          ),
        ),
      ),
    );
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
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




// class LeaveApplicationsPage extends StatelessWidget {
//   const LeaveApplicationsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Leave Management',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.indigo,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Leave Balance Card
//             Card(
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               color: Colors.indigoAccent,
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Your Leave Balance',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: const [
//                         LeaveBalanceCard(
//                           leaveType: 'Casual Leave',
//                           leaveCount: '5',
//                           color: Colors.orange,
//                         ),
//                         LeaveBalanceCard(
//                           leaveType: 'Sick Leave',
//                           leaveCount: '2',
//                           color: Colors.red,
//                         ),
//                         LeaveBalanceCard(
//                           leaveType: 'Annual Leave',
//                           leaveCount: '8',
//                           color: Colors.green,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Apply for Leave Button
//             ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/apply_leave');
//               },
//               icon: const Icon(Icons.add),
//               label: const Text('Apply for Leave'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.indigo,
//                 minimumSize: const Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Leave History Section
//             const Text(
//               'Leave History',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 5, // Replace with actual leave history count
//                 itemBuilder: (context, index) {
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 2,
//                     child: ListTile(
//                       leading: Icon(
//                         Icons.calendar_today,
//                         color: Colors.indigo,
//                       ),
//                       title: const Text('Casual Leave'),
//                       subtitle: const Text('Approved on 2025-01-01'),
//                       trailing: Text(
//                         '3 Days',
//                         style: TextStyle(
//                           color: Colors.indigoAccent,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class LeaveBalanceCard extends StatelessWidget {
//   final String leaveType;
//   final String leaveCount;
//   final Color color;
//
//   const LeaveBalanceCard({
//     super.key,
//     required this.leaveType,
//     required this.leaveCount,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: color,
//           radius: 30,
//           child: Text(
//             leaveCount,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           leaveType,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//           ),
//         ),
//       ],
//     );
//   }
// }
