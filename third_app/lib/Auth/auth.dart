import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  // Future<User?> createUserWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     final cred = await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     return cred.user;
  //   } catch (e) {
  //     log("Something went wrong");
  //   }
  //   return null;
  // }
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        log("The email address is already in use by another account.");
      } else {
        log("An error occurred: ${e.message}");
      }
    } catch (e) {
      log("Something went wrong: $e");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong");
    }
  }
}
