import 'package:flutter/material.dart';
void main() {
  runApp(const MyFirstApp());
}
class MyFirstApp extends StatelessWidget {
  const MyFirstApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("If Lost, Contact"),
        ),
        body: const Center(
          child: Text(
            "Name : Devansh \n Phone : +91 99678 92886",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}