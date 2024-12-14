import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRecoveryData extends StatefulWidget {
  final Map<String, dynamic> data;

  EditRecoveryData({required this.data});

  @override
  _EditRecoveryDataState createState() => _EditRecoveryDataState();
}

class _EditRecoveryDataState extends State<EditRecoveryData> {
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  late TextEditingController _fullName;
  late TextEditingController _mothersMaidenName;
  late TextEditingController _bestFriendName;
  late TextEditingController _petName;
  late TextEditingController _ownQ;
  late TextEditingController _ownA;

  @override
  void initState() {
    super.initState();
    _fullName = TextEditingController(text: widget.data['fullName']);
    _mothersMaidenName = TextEditingController(text: widget.data['mothersMaidenName']);
    _bestFriendName = TextEditingController(text: widget.data['bestFriendName']);
    _petName = TextEditingController(text: widget.data['petName']);
    _ownQ = TextEditingController(text: widget.data['ownQuestion']);
    _ownA = TextEditingController(text: widget.data['ownAnswer']);
  }

  void _updateData() async {
    if (user == null) return;

    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('recovery_data')
            .doc(user!.uid)
            .update({
          'fullName': _fullName.text.trim(),
          'mothersMaidenName': _mothersMaidenName.text.trim(),
          'bestFriendName': _bestFriendName.text.trim(),
          'petName': _petName.text.trim(),
          'ownQuestion': _ownQ.text.trim(),
          'ownAnswer': _ownA.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data updated successfully!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating data: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Recovery Data"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Full Name", _fullName),
              _buildTextField("Mother's Maiden Name", _mothersMaidenName),
              _buildTextField("Best Friend's Name", _bestFriendName),
              _buildTextField("Pet's Name", _petName),
              _buildTextField("Custom Security Question", _ownQ),
              _buildTextField("Answer for Custom Question", _ownA),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
                child: const Text(
                  "Update",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        validator: (value) => value == null || value.trim().isEmpty
            ? "This field is required"
            : null,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.purple.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullName.dispose();
    _mothersMaidenName.dispose();
    _bestFriendName.dispose();
    _petName.dispose();
    _ownQ.dispose();
    _ownA.dispose();
    super.dispose();
  }

}
