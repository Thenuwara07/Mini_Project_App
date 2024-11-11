import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountView extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Define the getUserData function
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (document.exists) {
        return document.data() as Map<String, dynamic>?;
      } else {
        print("User document not found.");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    // Check if the user is null and handle it accordingly
    if (user == null) {
      return Center(
        child: Text("No user is currently logged in."),
      );
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: getUserData(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          var userData = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Name: ${userData['name'] ?? 'N/A'}"),
              Text("Email: ${userData['email'] ?? 'N/A'}"),
              userData['profilePicture'] != null
                  ? Image.network(userData['profilePicture'])
                  : Icon(Icons.account_circle, size: 100),
            ],
          );
        } else {
          return Center(
            child: Text("User data not found."),
          );
        }
      },
    );
  }
}
