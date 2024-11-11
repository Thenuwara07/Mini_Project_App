
import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  final String name;

  GreetingWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Hello, $name!',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}