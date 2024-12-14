import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:third_app/Auth/login.dart';
import 'package:third_app/Auth/auth.dart';
import 'package:third_app/db/biodata.dart';
import 'package:third_app/view/biodataform.dart';
import 'package:third_app/view/biodataview.dart';
import 'package:third_app/view/profile.dart';
import 'package:third_app/view/recoverydata.dart';
import 'package:rxdart/rxdart.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  final user = FirebaseAuth.instance.currentUser;
  final DatabaseService database = DatabaseService(collectionPath: 'biodata');

  // Function to show warning popup
  Future<void> showDeleteWarningDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning', style: TextStyle(color: Colors.red)),
          content: Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Colors.purple)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog before deleting
                await deleteAccount(context); // Call delete account function
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Function to delete account
  Future<void> deleteAccount(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account and data deleted successfully.")),
        );

        // Delete the user's document from Firestore
        await FirebaseFirestore.instance
            .collection('recovery_data')
            .doc(uid)
            .delete();

        // Delete the user's account from FirebaseAuth
        await user.delete();

        // Sign out the user to ensure Firebase clears the session
        await FirebaseAuth.instance.signOut();

        

        // Navigate to login screen after account deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No user is currently logged in.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting account: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BioMark",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false, // Removes the back arrow
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align buttons to the bottom
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center align content
              children: [
                const SizedBox(height: 100),

                // StreamBuilder to check if biodata and recovery data exist
                StreamBuilder<List<DocumentSnapshot>>(
                  stream: CombineLatestStream.list([
                    database.getDocuments('bio_data'), // First stream
                    database.getDocuments('recovery_data'), // Second stream
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return const Text("Error loading data");
                    }

                    final bioDataDocument =
                        snapshot.data?[0]?.data() as Map<String, dynamic>?;
                    final recoveryDataDocument =
                        snapshot.data?[1]?.data() as Map<String, dynamic>?;
                    final bool hasBioData = bioDataDocument != null;
                    final bool hasRecoveryData = recoveryDataDocument != null;

                    final buttonColor =
                        hasBioData ? Colors.green : Colors.purple;

                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      hasBioData ? BioDataView() : Biodata(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                            ),
                            child: Text(
                              hasBioData ? "View BioData" : "Add BioData",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => hasRecoveryData
                                      ? ViewRecoveryData()
                                      : RecoveryData(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hasRecoveryData
                                  ? Colors.green
                                  : Colors.purple,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                            ),
                            child: Text(
                              hasRecoveryData
                                  ? "View Profile Data"
                                  : "Add Recovery Data",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 200),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the buttons
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: ElevatedButton(
                        onPressed: () {
                          showDeleteWarningDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                        ),
                        child: const Text(
                          "Delete Account",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _auth.signout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                        ),
                        child: const Text(
                          "Sign Out",
                          style: TextStyle(color: Colors.purple, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
