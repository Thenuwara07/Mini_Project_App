import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:third_app/Auth/auth.dart';
import 'package:third_app/Auth/signup.dart';
import 'package:third_app/view/fpview.dart';
import 'package:third_app/view/home.dart';
import 'package:third_app/view/biodataform.dart';
// import 'package:third_app/Auth/forget_password.dart';  // Import the Forget Password screen

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool isVisible = true;
  bool isLogin = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _email,
                    hintText: 'Email',
                    icon: Icons.person,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _password,
                    hintText: 'Password',
                    icon: Icons.lock,
                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  if (isLogin)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Username or Password is incorrect",
                        style: TextStyle(
                          color: Color.fromARGB(255, 206, 16, 2), 
                          fontSize: 16
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 20, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'SIGNUP',
                          style: TextStyle(color: Colors.purple),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),  // Space between buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Forgot your password?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPasswordScreen(),  // Navigate to Forget Password screen
                            ),
                          );
                        },
                        child: const Text(
                          'RESET HERE',
                          style: TextStyle(color: Colors.purple),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Biodata(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Colors.purple),
                        ),
                        child: const Text(
                          'Fill as a Volunteer',
                          style: TextStyle(
                            color: Colors.purple, 
                            fontSize: 20, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.purple.withOpacity(.1),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? isVisible : false,
        validator: validator,
        decoration: InputDecoration(
          icon: Icon(icon),
          border: InputBorder.none,
          hintText: hintText,
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                )
              : null,
        ),
      ),
    );
  }

  void goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );

  void _login() async {
    final user = await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);
    if (user != null) {
      log("User Logged In");
      goToHome(context);
    } else {
      setState(() {
        isLogin = true;
      });
    }
  }
}
