import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase properly
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ForgetPasswordScreen(),
    );
  }
}

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Check if the email exists in Firebase Auth
  Future<void> _checkEmailExistence() async {
    final String email = _emailController.text.trim();

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Check if the email exists in Firebase Authentication
        final List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        
        if (signInMethods.isNotEmpty) {
          // Email exists
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Email exists! Proceed to the next step.')),
          );
          // Proceed to the next screen
          _proceedToNextStep();
        } else {
          // Email does not exist
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Email not found. Please try again.')),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ Error: ${e.message}')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _proceedToNextStep() {
    // Navigate to the next screen (e.g., OTP verification, security question, etc.)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
    );
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget Password'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your email to check if it is registered:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!_isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _checkEmailExistence,
                      child: const Text('Check Email'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: const Text('This is where you reset the password.'),
      ),
    );
  }
}
