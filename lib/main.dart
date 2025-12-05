import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const EvenOddChecker(),
    );
  }
}

class EvenOddChecker extends StatefulWidget {
  const EvenOddChecker({super.key});

  @override
  State<EvenOddChecker> createState() => _EvenOddCheckerState();
}

class _EvenOddCheckerState extends State<EvenOddChecker> {
  final TextEditingController numberController = TextEditingController();
  String resultMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Even / Odd Checker"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter a number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String input = numberController.text;
                int number = int.parse(input);
                if (number % 2 == 0) {
                  resultMessage = "The number $number is Even.";
                } else {
                  resultMessage = "The number $number is Odd.";
                }
                setState(() {});
              },
              child: const Text("Check"),
            ),
            const SizedBox(height: 20),
            Text(
              resultMessage,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
