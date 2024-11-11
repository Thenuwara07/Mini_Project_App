import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseServices {
  final String baseUrl = "http://192.168.8.186:3000";

  Future<bool> createToDo( String userId, String fullname, String mothername, String bfriendname, String petname, String ownq, String owna) async {
    final url = Uri.parse("$baseUrl/createToDo");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"userId" : userId, "fullname": fullname, "mothername": mothername, "bestfriendname": bfriendname, "petname": petname, "ownq": ownq, "owna": owna}),
      );

      if (response.statusCode == 200) {
        return true; // To-do created successfully
      } else {
        print("Failed to create To-Do: ${response.statusCode} - ${response.body}");
        return false; // Failed to create to-do
      }
    } catch (error) {
      print("Error creating To-Do: $error");
      return false;
    }
  }

  Future<Map<String, dynamic>> getToDo(String userId) async {
  final url = Uri.parse("$baseUrl/getUserTodoList");

  try {
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // Assuming the response is a JSON object
      return json.decode(response.body);
    } else {
      print("Failed to get To-Do: ${response.statusCode} - ${response.body}");
      return {}; // Returning an empty map on failure
    }
  } catch (error) {
    print("Error fetching To-Do: $error");
    return {}; // Returning an empty map in case of an error
  }
}

}
