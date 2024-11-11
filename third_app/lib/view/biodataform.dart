import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:third_app/Auth/login.dart';
import 'package:third_app/db/biodata.dart';
import 'package:intl/intl.dart';
import 'package:third_app/view/home.dart';

class Biodata extends StatefulWidget {
  @override
  _BiodataState createState() => _BiodataState();
}

class _BiodataState extends State<Biodata> {
  final _formKey = GlobalKey<FormState>();

  final user = FirebaseAuth.instance.currentUser;

  final DatabaseService database = DatabaseService(collectionPath: 'biodata');

  // Controllers for each field
  final _dobController = TextEditingController();
  final _timeOfBirthController = TextEditingController();
  final _locationOfBirthController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _heightController = TextEditingController();
  final _ethnicityController = TextEditingController();
  final _eyeColorController = TextEditingController();

  // Variable for selected sex
  String? _selectedSex;

  void _addData() {
    if (_dobController.text.isNotEmpty &&
        _timeOfBirthController.text.isNotEmpty &&
        _locationOfBirthController.text.isNotEmpty &&
        _bloodGroupController.text.isNotEmpty &&
        _heightController.text.isNotEmpty &&
        _ethnicityController.text.isNotEmpty &&
        _eyeColorController.text.isNotEmpty) {
      database.addDocument({
        'dateOfBirth': Timestamp.fromDate(DateTime.parse(_dobController.text)),
        'timeOfBirth': _timeOfBirthController.text,
        'locationOfBirth': _locationOfBirthController.text,
        'bloodGroup': _bloodGroupController.text,
        'sex': _selectedSex.toString(),
        'height': double.tryParse(_heightController.text),
        'ethnicity': _ethnicityController.text,
        'eyeColor': _eyeColorController.text,
        'createdAt': Timestamp.now(),
      });

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
  }

  void _clearFields() {
    _dobController.clear();
    _timeOfBirthController.clear();
    _locationOfBirthController.clear();
    _bloodGroupController.clear();
    _heightController.clear();
    _ethnicityController.clear();
    _eyeColorController.clear();
    setState(() {
      _selectedSex = null;
    });
  }

  @override
  void dispose() {
    _dobController.dispose();
    _timeOfBirthController.dispose();
    _locationOfBirthController.dispose();
    _bloodGroupController.dispose();
    _heightController.dispose();
    _ethnicityController.dispose();
    _eyeColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fill Your BioData Form",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false, // This removes the back arrow
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildTextField("Date of Birth (YYYY-MM-DD)", _dobController),
                  _buildTextField(
                      "Time of Birth (HH:MM)", _timeOfBirthController),
                  _buildTextField(
                      "Location of Birth", _locationOfBirthController),
                  _buildTextField("Blood Group", _bloodGroupController),
                  _buildDropdownField(),
                  _buildTextField("Height", _heightController),
                  _buildTextField("Ethnicity", _ethnicityController),
                  _buildTextField("Eye Color", _eyeColorController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addData();
                        print("Form submitted");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                    ),
                    child: const Text(
                      "Submit",
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
          hintText: "$hint",
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your $hint";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.purple.withOpacity(0.1),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedSex,
        hint: const Text("Sex"),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        items: ['Male', 'Female', 'Other']
            .map((sex) => DropdownMenuItem(
                  value: sex,
                  child: Text(sex),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedSex = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please select your sex";
          }
          return null;
        },
      ),
    );
  }
}
