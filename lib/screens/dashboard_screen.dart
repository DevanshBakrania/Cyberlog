import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'vault_gate_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String publicIP = 'Fetching...';
  bool isLoadingIP = true;
  String deviceModel = 'Loading...';
  String osVersion = 'Loading...';

  final List<String> securityTips = [
    'Keep your operating system up to date',
    'Use strong and unique passwords',
    'Enable two-factor authentication (2FA) on all accounts',
    'Avoid connecting to unsecured public Wi-Fi',
    'Be cautious of phishing emails and suspicious links',
    'Enable biometric authentication wherever possible',
    'Regularly review and revoke app permissions',
    'Backup your data regularly to secure cloud or external drives',
    'Use a password manager to generate and store complex passwords',
    'Install reputable antivirus or security software',
    'Enable device encryption and lock screen'
  ];

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
    fetchPublicIP();
  }

  Future<void> fetchPublicIP() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.ipify.org?format=json'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          publicIP = data['ip'];
          isLoadingIP = false;
        });
      } else {
        publicIP = 'Failed';
        isLoadingIP = false;
      }
    } catch (_) {
      publicIP = 'Network Error';
      isLoadingIP = false;
    }
  }

  Future<void> _loadDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        setState(() {
          deviceModel = androidInfo.model;
          osVersion = 'Android ${androidInfo.version.release}';
        });
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        setState(() {
          deviceModel = iosInfo.utsname.machine;
          osVersion = 'iOS ${iosInfo.systemVersion}';
        });
      }
    } catch (_) {
      deviceModel = 'Unknown';
      osVersion = 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020617),
        title: const Text(
          'CyberShield',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHardwareAuditCard(),
            const SizedBox(height: 16),
            _buildNetworkIntelCard(),
            const SizedBox(height: 16),
            _buildSecurityFeedCard(),
            const SizedBox(height: 16),
            _buildVaultCard(), 
          ],
        ),
      ),
    );
  }
-
  Widget _buildHardwareAuditCard() {
    return _cyberCard(
      icon: Icons.devices,
      iconColor: Colors.cyanAccent,
      title: 'Hardware Audit',
      content: 'Device: $deviceModel\nOS: $osVersion',
    );
  }

  Widget _buildNetworkIntelCard() {
    return _cyberCard(
      icon: Icons.public,
      iconColor: Colors.greenAccent,
      title: 'Network Intel',
      content: isLoadingIP ? 'Fetching public IP...' : 'Public IP: $publicIP',
    );
  }

  Widget _buildSecurityFeedCard() {
    return Card(
      color: const Color(0xFF020617),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Security Feed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...securityTips.map(
                  (tip) => ListTile(
                dense: true,
                leading: const Icon(Icons.security, color: Colors.orangeAccent),
                title: Text(
                  tip,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaultCard() {
    return Card(
      color: const Color(0xFF020617),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.lock, color: Colors.redAccent, size: 32),
        title: const Text(
          'Encrypted Vault',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          'Biometrically protected secure storage',
          style: TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const VaultGateScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _cyberCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Card(
      color: const Color(0xFF020617),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    content,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
