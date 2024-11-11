import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:third_app/Auth/auth.dart';
import 'package:third_app/Auth/signup.dart';
import 'package:third_app/view/home.dart';
import 'package:third_app/view/biodataform.dart';
import 'package:third_app/view/crudui.dart';
import 'package:third_app/view/view.dart';

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
                children: [
                  const SizedBox(height: 15),
                  const ListTile(
                    title: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.purple),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(7),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.purple.withOpacity(.1)),
                    child: TextFormField(
                      controller: _email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: 'Username',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(7),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.purple.withOpacity(.1)),
                    child: TextFormField(
                      controller: _password,
                      obscureText: isVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(isVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (isLogin) // Only show error message if login failed
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Username or Password is incorrect",
                        style: TextStyle(color: Color.fromARGB(255, 206, 16, 2), fontSize: 16),
                      ),
                    ),
                  const SizedBox(height: 5),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.purple,
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                        child: const Text('SIGNUP', style: TextStyle(color: Colors.purple)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width * .7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Biodata(),
                            ),
                          );
                      },
                      child: const Text(
                        'Fill as a volunteer',
                        style: TextStyle(color: Colors.purple, fontSize: 20),
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

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );

  _login() async {
    final user =
        await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);

    if (user != null) {
      log("User Logged In");
      goToHome(context);
    } else {
      setState(() {
        isLogin = true; // Show error message if login fails
      });
    }
  }
}

