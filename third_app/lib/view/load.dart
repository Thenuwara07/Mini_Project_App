
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:third_app/Auth/login.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    // Simulate data loading or initialization here
    await Future.delayed(const Duration(seconds: 3)); // Simulate a delay
    // After data is loaded, navigate to Login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BioMark',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              color: Colors.white, // Customize the color if needed
            ),
          ],
        ),
      ),
    );
  }
}
