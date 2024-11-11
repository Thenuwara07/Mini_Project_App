import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:third_app/db/biodata.dart';
import 'package:third_app/db/database.dart';
import 'package:third_app/view/profile.dart';

class RecoveryData extends StatefulWidget {
  @override
  _RecoveryDataState createState() => _RecoveryDataState();
}

class _RecoveryDataState extends State<RecoveryData> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _mothersmaidenName = TextEditingController();
  final TextEditingController _bestfriendName = TextEditingController();
  final TextEditingController _petName = TextEditingController();
  final TextEditingController _ownQ = TextEditingController();
  final TextEditingController _ownA = TextEditingController();
  bool _isLoading = false;

  Future<void> _RecoveryData() async {
    setState(() {
      _isLoading = true;
    });

    final dbService = DatabaseServices();
    final User? user = FirebaseAuth.instance.currentUser;
    final String userUid = user?.uid ?? 'No UID available';

    // Create the to-do item with all fields, passing the parsed DateTime directly
    final success = await dbService.createToDo(
      userUid,
      _fullName.text,
      _mothersmaidenName.text,
      _bestfriendName.text,
      _petName.text,
      _ownQ.text,
      _ownA.text,
    );

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(success
              ? "To-Do created successfully!"
              : "Failed to create To-Do")),
    );

    if (success) {
      _clearFields();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
    }
  }

  void _clearFields() {
    _fullName.clear();
    _mothersmaidenName.clear();
    _bestfriendName.clear();
    _petName.clear();
    _ownQ.clear();
    _ownA.clear();
  }

  @override
  void dispose() {
    _fullName.dispose();
    _mothersmaidenName.dispose();
    _bestfriendName.dispose();
    _petName.dispose();
    _ownQ.dispose();
    _ownA.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fill in your Recovery Data",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTextField("Full Name", _fullName),
                _buildTextField("Mother's Maiden Name", _mothersmaidenName),
                _buildTextField(
                    "Childhood Best Friend's Name", _bestfriendName),
                _buildTextField("Childhood Pet's Name", _petName),
                _buildTextField("Your Own Question", _ownQ),
                _buildTextField("Answer For your own Question", _ownA),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _RecoveryData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.purple.withOpacity(0.1),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $hint";
          }
          return null;
        },
      ),
    );
  }
}
