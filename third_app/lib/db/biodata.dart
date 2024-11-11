import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:third_app/Auth/login.dart';

class DatabaseService {
  final CollectionReference collection;

  DatabaseService({required String collectionPath})
      : collection = FirebaseFirestore.instance.collection("data");
  final sus = "Data added successfully";

  // Create - Add a new document
  // Future<void> addDocument(Map<String, dynamic> data) async {
  //   try {
  //     await collection.add(data);
  //   } catch (e) {
  //     print("Error adding document: $e");
  //   }
  // }

  Future<void> addDocument(Map<String, dynamic> data) async {
    try {
      // Get the current user's UID
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Use the UID as the document ID
        await FirebaseFirestore.instance
            .collection('bio_data')
            .doc(user.uid)
            .set(data);
      } else {
        await FirebaseFirestore.instance.collection('bio_data').doc().set(data);
      }
    } catch (e) {
      print("Error adding document: $e");
    }
  }

  // Read - Get all documents as a stream

  Stream<DocumentSnapshot> getDocuments() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Return a stream of the document that matches the user's UID
      return FirebaseFirestore.instance
          .collection('bio_data')
          .doc(user.uid)
          .snapshots();
    } else {
      // Handle the case where there's no authenticated user
      throw Exception("No authenticated user.");
    }
  }

  // Update - Update an existing document
  Future<void> updateDocument(String docId, Map<String, dynamic> data) async {
    try {
      await collection.doc(docId).update(data);
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  // Delete - Delete a document
  Future<void> deleteDocument(String docId) async {
    try {
      await collection.doc(docId).delete();
    } catch (e) {
      print("Error deleting document: $e");
    }
  }
}
