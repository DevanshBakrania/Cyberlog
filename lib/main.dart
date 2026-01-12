import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const CyberLogApp());
}

class CyberLogApp extends StatelessWidget {
  const CyberLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CyberLog',
      theme: ThemeData.dark(useMaterial3: true),
      home: const SecurityDashboard(),
    );
  }
}

class SecurityDashboard extends StatefulWidget {
  const SecurityDashboard({super.key});

  @override
  State<SecurityDashboard> createState() => _SecurityDashboardState();
}

class _SecurityDashboardState extends State<SecurityDashboard> {
  bool screenLockEnabled = true; 
  bool rootedOrEmulator = false; 

  List<String> dangerousPermissions = [];
  List<String> securityLogs = [];

  int deviceScore = 30;
  int permissionScore = 40;
  int awarenessScore = 20;

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.location,
      Permission.storage,
    ].request();

    List<String> granted = [];

    statuses.forEach((permission, status) {
      if (status.isGranted) {
        final name = permission.toString().split('.').last;
        granted.add(name);
        securityLogs.add("$name permission granted");
      }
    });

    setState(() {
      dangerousPermissions = granted;
      permissionScore = 40 - (granted.length * 8);
      if (permissionScore < 0) permissionScore = 0;
    });
  }

  int get totalScore => deviceScore + permissionScore + awarenessScore;

  Color scoreColor() {
    if (totalScore >= 80) return Colors.green;
    if (totalScore >= 50) return Colors.orange;
    return Colors.red;
  }

  List<String> recommendations() {
    List<String> tips = [];

    if (!screenLockEnabled) {
      tips.add("Enable screen lock to protect your device");
    }
    if (dangerousPermissions.isNotEmpty) {
      tips.add("Review granted dangerous permissions");
    }
    if (rootedOrEmulator) {
      tips.add("Avoid using rooted or emulated devices");
    }
    if (tips.isEmpty) {
      tips.add("Your security posture is strong");
    }

    return tips;
  }

  Widget scoreCard(String title, int score, int max) {
    return ListTile(
      title: Text(title),
      subtitle: LinearProgressIndicator(value: score / max),
      trailing: Text("$score / $max"),
    );
  }

  Widget owaspStatusTile(String title, bool isSecure) {
    return ListTile(
      title: Text(title),
      trailing: Icon(
        isSecure ? Icons.check_circle : Icons.warning_amber_rounded,
        color: isSecure ? Colors.green : Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CyberLog Security Dashboard")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Overall Security Score",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: CircularProgressIndicator(
                          value: totalScore / 100,
                          strokeWidth: 10,
                          color: scoreColor(),
                        ),
                      ),
                      Text(
                        "$totalScore",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: scoreColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    totalScore >= 80
                        ? "Secure Device"
                        : "Security Needs Improvement",
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Score Breakdown",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          scoreCard("Device Protection", deviceScore, 40),
          scoreCard("Permissions", permissionScore, 40),
          scoreCard("Security Awareness", awarenessScore, 20),

          const SizedBox(height: 20),

          ExpansionTile(
            leading: const Icon(Icons.lightbulb),
            title: const Text("Security Recommendations"),
            children: recommendations()
                .map(
                  (tip) => ListTile(
                leading: const Icon(Icons.arrow_right),
                title: Text(tip),
              ),
            )
                .toList(),
          ),

          ExpansionTile(
            leading: const Icon(Icons.history),
            title: const Text("Security Timeline"),
            children: securityLogs.isEmpty
                ? const [
              ListTile(title: Text("No security events logged"))
            ]
                : securityLogs
                .map(
                  (log) => ListTile(
                leading: const Icon(Icons.event),
                title: Text(log),
              ),
            )
                .toList(),
          ),

          ExpansionTile(
            leading: const Icon(Icons.security),
            title: const Text("OWASP Mobile Top 10 Mapping"),
            children: [
              owaspStatusTile(
                "M3 – Insecure Authentication",
                screenLockEnabled,
              ),
              owaspStatusTile(
                "M5 – Insecure Communication",
                !dangerousPermissions.contains("location"),
              ),
              owaspStatusTile(
                "M9 – Insecure Data Storage",
                dangerousPermissions.isEmpty,
              ),
            ],
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            icon: const Icon(Icons.settings),
            label: const Text("Open App Settings"),
            onPressed: openAppSettings,
          ),
        ],
      ),
    );
  }
}
