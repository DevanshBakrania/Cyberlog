import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CyberLogPage(),
    );
  }
}

class Log {
  String action;
  DateTime timestamp;
  String status;

  Log(this.action, this.timestamp, this.status);
}

class CyberLogPage extends StatelessWidget {
  CyberLogPage({super.key});

  final List<Log> logs = [
    Log("Login Attempt", DateTime.now(), "Success"),
    Log("Password Change", DateTime.now(), "Failed"),
    Log("File Download", DateTime.now(), "Success"),
    Log("Unauthorized Access", DateTime.now(), "Blocked"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cyber Logs")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: logs.map((log) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "${log.action}   |   ${log.timestamp.toLocal().toString().split(".")[0]}   |   ${log.status}",
                style: const TextStyle(fontSize: 18),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
