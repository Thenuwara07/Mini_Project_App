
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:third_app/db/biodata.dart';
import 'package:third_app/view/home.dart';
import 'package:third_app/Auth/login.dart';

class RecoveryData extends StatefulWidget {
  @override
  _RecoveryDataState createState() => _RecoveryDataState();
}

class _RecoveryDataState extends State<RecoveryData> {
  final _formKey = GlobalKey<FormState>();

  final user = FirebaseAuth.instance.currentUser;

  final DatabaseService database =
      DatabaseService(collectionPath: 'recoverydata');

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _mothersMaidenName = TextEditingController();
  final TextEditingController _bestFriendName = TextEditingController();
  final TextEditingController _petName = TextEditingController();
  final TextEditingController _ownQ = TextEditingController();
  final TextEditingController _ownA = TextEditingController();

  bool _isLoading = false;

  void _addData() {
    if (user == null) {
      throw Exception("User not authenticated");
    }
    try {

      if (_fullName.text.isNotEmpty &&
          _mothersMaidenName.text.isNotEmpty &&
          _bestFriendName.text.isNotEmpty &&
          _petName.text.isNotEmpty &&
          _ownQ.text.isNotEmpty &&
          _ownA.text.isNotEmpty) {
        database.addDocument('recovery_data', {
          'fullName': _fullName.text.trim(),
          'mothersMaidenName': _mothersMaidenName.text.trim(),
          'bestFriendName': _bestFriendName.text.trim(),
          'petName': _petName.text.trim(),
          'ownQuestion': _ownQ.text.trim(),
          'ownAnswer': _ownA.text.trim(),
          // 'userId': user.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data saved successfully!")),
        );
        Future<void> delayedFunction() async {
          await Future.delayed(const Duration(seconds: 2));
        }

        delayedFunction();

        _clearFields();
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearFields() {
    _fullName.clear();
    _mothersMaidenName.clear();
    _bestFriendName.clear();
    _petName.clear();
    _ownQ.clear();
    _ownA.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fill in your Recovery Data",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField("Full Name", _fullName),
                  _buildTextField("Mother's Maiden Name", _mothersMaidenName),
                  _buildTextField("Best Friend's Name", _bestFriendName),
                  _buildTextField("Pet's Name", _petName),
                  _buildTextField("Custom Security Question", _ownQ),
                  _buildTextField("Answer for Custom Question", _ownA),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _addData();
                            }
                          },
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
}
