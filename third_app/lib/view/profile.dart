import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:third_app/view/editprofile.dart';

class ViewRecoveryData extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "View Recovery Data",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        iconTheme: const IconThemeData(color: Colors.white), // Back arrow color
      ),
      body: user == null
          ? Center(
              child: const Text(
                "You need to be logged in to view recovery data.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('recovery_data')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                    child: const Text(
                      "No Recovery Data found.",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildDataRow("Full Name", data['fullName'] ?? 'N/A'),
                        _buildDataRow("Email", user?.email ?? 'N/A'),
                        _buildDataRow("Mother's Maiden Name", data['mothersMaidenName'] ?? 'N/A'),
                        _buildDataRow("Best Friend's Name", data['bestFriendName'] ?? 'N/A'),
                        _buildDataRow("Pet's Name", data['petName'] ?? 'N/A'),
                        _buildDataRow("Custom Security Question", data['ownQuestion'] ?? 'N/A'),
                        _buildDataRow("Answer for Custom Question", data['ownAnswer'] ?? 'N/A'),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditRecoveryData(data: data),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                            ),
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 20, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  /// Builds a reusable card-style layout for displaying a data field.
Widget _buildDataRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  

} 
