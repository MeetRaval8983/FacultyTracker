import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserLeave extends StatefulWidget {
  const UserLeave({super.key});

  @override
  State<UserLeave> createState() => _UserLeaveState();
}

class _UserLeaveState extends State<UserLeave> {

  final List<String> leaveType = ['Short leave', 'Sick leave', 'Casual leave', 'Annual leave', 'Other'];
  String? selectedLeave;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  String? firstname;
  String? lastname;
  String? email;
  String? mobile;
  String? department;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  void dispose() {
    // Always dispose controllers when done to free up resources
    startDateController.dispose();
    endDateController.dispose();
    reasonController.dispose();
    super.dispose();
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
            firstname = userDoc['firstname'];
            lastname = userDoc['lastname'];
            email = currentUser.email;
            mobile = userDoc['mobile'];
            department = userDoc['department'];
          });
        }
        print(firstname);
        print(lastname);
        print(email);
        print(mobile);
        print(department);
      } catch (e) {
        print("Error fetching user details: $e");
      }
    }
  }

  Future<void> pickDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2099)
    );

    if(pickedDate != null) {
      setState(() {
        controller.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }

  Future<void> submitLeave() async {
    if(startDateController.text.isEmpty ||
        endDateController.text.isEmpty ||
        reasonController.text.isEmpty ||
        selectedLeave == null ||
        firstname == null ||
        lastname == null ||
        email == null ||
        mobile == null ||
        department == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the details'))
      );
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('leaveApplication')
          .add({
        'startDate': startDateController.text,
        'endDate': endDateController.text,
        'reason': reasonController.text,
        'leaveType': selectedLeave,
        'timeStamp': FieldValue.serverTimestamp(),
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'mobile': mobile,
        'department': department,
        'status': 'Pending'
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Leave application submitted successfully'))
      );
      startDateController.clear();
      endDateController.clear();
      reasonController.clear();
      setState(() {
        selectedLeave = null;
      });
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting leave: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Application'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: startDateController,
                readOnly: true,
                decoration:InputDecoration(
                  hintText: 'Start Date',
                  suffixIcon: IconButton(
                      onPressed: () async {
                        pickDate(context, startDateController);
                      },
                      icon: Icon(Icons.calendar_today)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  )
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: endDateController,
                readOnly: true,
                decoration:InputDecoration(
                    hintText: 'End Date',
                    suffixIcon: IconButton(
                        onPressed: () async {
                          pickDate(context, endDateController);
                        },
                        icon: Icon(Icons.calendar_today)
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: 15,),
              Text('Leave type',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              ),
              SizedBox(height: 10,),
              Column(
                children: leaveType.map((String l) {
                  return RadioListTile(
                      title: Text(l),
                      value: l,
                      groupValue: selectedLeave,
                      onChanged: (String? v) {
                        setState(() {
                          selectedLeave = v;
                        });
                      }
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
              TextField(
                controller: reasonController,
                maxLines: 5,
                decoration:InputDecoration(
                    hintText: 'Reason for Leave',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                    onPressed: submitLeave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue
                    ),
                    child: Text('Submit Leave Report',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                    ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}








// import 'package:flutter/material.dart';
//
// class UserLeave extends StatefulWidget {
//   @override
//   _UserLeavePageState createState() => _UserLeavePageState();
// }
//
// class _UserLeavePageState extends State<UserLeave> {
//   // Declare the TextEditingController
//   TextEditingController startDateController = TextEditingController();
//   TextEditingController endDateController = TextEditingController();
//   TextEditingController reasonController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     // You can initialize the controllers with any default text if needed
//     startDateController.text = ''; // optional, just to set an initial value
//     endDateController.text = ''; // optional, just to set an initial value
//   }
//
//   @override
//   void dispose() {
//     // Always dispose controllers when done to free up resources
//     startDateController.dispose();
//     endDateController.dispose();
//     reasonController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('User Leave Page')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Start Date
//             TextField(
//               controller: startDateController,
//               decoration: InputDecoration(
//                 labelText: 'Start Date',
//                 hintText: 'Select start date',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.calendar_today),
//                   onPressed: () async {
//                     // Show Date Picker to select date
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2020),
//                       lastDate: DateTime(2100),
//                     );
//                     if (pickedDate != null) {
//                       setState(() {
//                         startDateController.text = "${pickedDate.toLocal()}"
//                             .split(' ')[0]; // Format the date to display
//                       });
//                     }
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // End Date
//             TextField(
//               readOnly: true,
//               controller: endDateController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15)
//                 ),
//                 labelText: 'End Date',
//                 hintText: 'Select end date',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.calendar_today),
//                   onPressed: () async {
//                     // Show Date Picker to select date
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2020),
//                       lastDate: DateTime(2100),
//                     );
//                     if (pickedDate != null) {
//                       setState(() {
//                         endDateController.text = "${pickedDate.toLocal()}"
//                             .split(' ')[0]; // Format the date to display
//                       });
//                     }
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // Reason for Leave
//             TextField(
//               controller: reasonController,
//               decoration: InputDecoration(
//                 labelText: 'Reason for Leave',
//                 hintText: 'Enter reason for leave',
//               ),
//             ),
//             SizedBox(height: 30),
//
//             // Submit Button
//             ElevatedButton(
//               onPressed: () {
//                 // Handle leave request submission
//                 String startDate = startDateController.text;
//                 String endDate = endDateController.text;
//                 String reason = reasonController.text;
//                 // Logic to submit leave request (e.g., save to Firebase)
//                 print(
//                     "Start Date: $startDate, End Date: $endDate, Reason: $reason");
//               },
//               child: Text('Submit Leave Request'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







// class UserLeave extends StatelessWidget {
//   const UserLeave({super.key});
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
