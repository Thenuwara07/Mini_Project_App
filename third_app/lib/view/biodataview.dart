import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BioDataView extends StatefulWidget {
  @override
  _BioDataViewState createState() => _BioDataViewState();
}

class _BioDataViewState extends State<BioDataView> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BioData",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: true, // Show back arrow
        iconTheme: const IconThemeData(
          color: Colors.white, // Change back arrow color to green
        ),
      ),
      body: user == null
          ? Center(
              child: const Text(
                "You need to be logged in to view your BioData.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bio_data')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                    child: const Text(
                      "No BioData found. Please submit your information.",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                final bioData = snapshot.data!.data() as Map<String, dynamic>;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildBioDataRow(
                          "Date of Birth", _formatDate(bioData['dateOfBirth'])),
                      _buildBioDataRow(
                          "Time of Birth", bioData['timeOfBirth'] ?? "N/A"),
                      _buildBioDataRow("Location of Birth",
                          bioData['locationOfBirth'] ?? "N/A"),
                      _buildBioDataRow(
                          "Blood Group", bioData['bloodGroup'] ?? "N/A"),
                      _buildBioDataRow("Sex", bioData['sex'] ?? "N/A"),
                      _buildBioDataRow("Height", "${bioData['height']} cm"),
                      _buildBioDataRow(
                          "Ethnicity", bioData['ethnicity'] ?? "N/A"),
                      _buildBioDataRow(
                          "Eye Color", bioData['eyeColor'] ?? "N/A"),
                      _buildBioDataRow(
                          "Created At", _formatDateTime(bioData['createdAt'])),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildBioDataRow(String label, String value) {
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

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "N/A";
    DateTime date = timestamp.toDate();
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _formatDateTime(Timestamp? timestamp) {
    if (timestamp == null) return "N/A";
    DateTime date = timestamp.toDate();
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
