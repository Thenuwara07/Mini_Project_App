// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:third_app/Auth/auth.dart';

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final _auth = AuthService();

//   // Function to show warning popup
//   Future<void> showDeleteWarningDialog(BuildContext context) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // Prevent closing the dialog by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Warning', style: TextStyle(color: Colors.red)),
//           content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Cancel', style: TextStyle(color: Colors.white)),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop(); // Close the dialog before deleting
//                 await deleteAccount(context); // Call delete account function
//               },
//               child: Text('Delete', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Function to delete account
//   Future<void> deleteAccount(BuildContext context) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;

//       if (user != null) {
//         String uid = user.uid;

//         // Delete the user's document from Firestore
//         await FirebaseFirestore.instance.collection('recovery_data').doc(uid).delete();

//         // Delete the user's account from FirebaseAuth
//         await user.delete();

//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Account and data deleted successfully.")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("No user is currently logged in.")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error deleting account: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "BioMark",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.purple,
//         automaticallyImplyLeading: false,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 100),
//               Container(
//                 margin: const EdgeInsets.all(8),
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     showDeleteWarningDialog(context); // Show warning dialog
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red[900],
//                     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
//                   ),
//                   child: const Text(
//                     "Delete Account",
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//               ),
//               // Other buttons and UI elements...
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
