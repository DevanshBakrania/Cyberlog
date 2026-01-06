import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(const CyberLogApp());
}

class CyberLogApp extends StatelessWidget {
  const CyberLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CyberLog",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF6F7F2),
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool cameraGranted = false;
  bool storageGranted = false;
  bool internetActive = false;

  File? image;
  String cyberTip = "";
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    refreshStatus();
  }

  void log(String msg) {
    final time = TimeOfDay.now().format(context);
    setState(() {
      logs.insert(0, "[$time] $msg");
    });
  }

  Future<void> refreshStatus() async {
    cameraGranted = await Permission.camera.isGranted;
    storageGranted = await Permission.photos.isGranted;

    final net = await Connectivity().checkConnectivity();
    internetActive = net != ConnectivityResult.none;

    setState(() {});
  }

  Future<void> openCamera() async {
    if (!cameraGranted) {
      final res = await Permission.camera.request();
      if (!res.isGranted) {
        log("Camera permission denied");
        return;
      }
    }

    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      image = File(picked.path);
      log("Image captured");
      setState(() {});
    }
  }

  Future<void> openStorage() async {
    if (!storageGranted) {
      final res = await Permission.photos.request();
      if (!res.isGranted) {
        log("Storage permission denied");
        return;
      }
    }

    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      image = File(picked.path);
      log("Image selected from storage");
      setState(() {});
    }
  }

  Future<void> fetchTip() async {
    await refreshStatus();

    if (!internetActive) {
      cyberTip = "No internet connection available.";
      log("Cyber tip failed (offline)");
    } else {
      cyberTip =
      "Always use strong passwords and enable two-factor authentication.";
      log("Cyber tip fetched");
    }
    setState(() {});
  }

  Widget statusChip(String label, bool ok) {
    return Chip(
      label: Text(label),
      backgroundColor: ok ? Colors.green.shade100 : Colors.red.shade100,
      labelStyle:
      TextStyle(color: ok ? Colors.green.shade900 : Colors.red.shade900),
    );
  }

  Widget sectionCard(String title, Widget child) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget actionButton(
      {required IconData icon,
        required String label,
        required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CyberLog Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshStatus,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            sectionCard(
              "Permission Status",
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  statusChip("Camera", cameraGranted),
                  statusChip("Storage", storageGranted),
                  statusChip("Internet", internetActive),
                ],
              ),
            ),

            const SizedBox(height: 16),

            actionButton(
              icon: Icons.camera_alt,
              label: "Capture Evidence",
              onTap: openCamera,
            ),
            const SizedBox(height: 10),
            actionButton(
              icon: Icons.folder_open,
              label: "Open Storage",
              onTap: openStorage,
            ),
            const SizedBox(height: 10),
            actionButton(
              icon: Icons.security,
              label: "Fetch Cyber Tip",
              onTap: fetchTip,
            ),

            const SizedBox(height: 20),

            if (image != null)
              sectionCard(
                "Captured Evidence",
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(image!),
                ),
              ),

            const SizedBox(height: 16),

            if (cyberTip.isNotEmpty)
              sectionCard("Cyber Tip", Text(cyberTip)),

            const SizedBox(height: 16),

            sectionCard(
              "Action Logs",
              logs.isEmpty
                  ? const Text("No actions recorded yet.")
                  : Column(
                children: logs
                    .map((e) => ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(e),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
