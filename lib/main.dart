import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CyberTipScreen(),
    );
  }
}

class CyberTipScreen extends StatefulWidget {
  const CyberTipScreen({Key? key}) : super(key: key);

  @override
  State<CyberTipScreen> createState() => _CyberTipScreenState();
}

class _CyberTipScreenState extends State<CyberTipScreen> {
  String tip = 'Tap button to get tip';
  bool loading = false;

  // Local cybersecurity tips (100+ tips)
  final List<String> cyberTips = [
    "Use strong passwords and enable 2FA",
    "Update software regularly",
    "Backup your data",
    "Be careful with email links",
    "Use antivirus software",
    "Don't use public Wi-Fi for sensitive tasks",
    "Log out when finished",
    "Check privacy settings",
    "Use a password manager",
    "Enable automatic screen lock",
    "Don't reuse passwords across sites",
    "Verify sender email addresses",
    "Use HTTPS websites only",
    "Don't download unknown attachments",
    "Secure your home Wi-Fi with WPA3",
    "Regularly clear browser cookies",
    "Use incognito mode for sensitive browsing",
    "Don't save passwords in browsers",
    "Enable find my device feature",
    "Review app permissions regularly",
    "Avoid oversharing on social media",
    "Use different email for important accounts",
    "Shred documents with personal info",
    "Monitor bank statements regularly",
    "Don't plug in unknown USB devices",
    "Use a VPN for extra privacy",
    "Disable auto-connect to Wi-Fi",
    "Set up security questions carefully",
    "Don't use obvious security answers",
    "Lock your devices when not in use",
    "Encrypt sensitive files",
    "Use secure messaging apps",
    "Disable location when not needed",
    "Turn off Bluetooth when not in use",
    "Keep router firmware updated",
    "Change default router passwords",
    "Use a guest network for visitors",
    "Disable remote management on router",
    "Regularly audit connected devices",
    "Use a separate network for IoT devices",
    "Enable login notifications",
    "Review account activity logs",
    "Don't click shortened URLs",
    "Hover over links to see real URL",
    "Check for spelling errors in emails",
    "Verify unexpected requests by phone",
    "Don't give info to unsolicited callers",
    "Use credit cards for online purchases",
    "Enable purchase notifications",
    "Store backups in different locations",
    "Test your backups regularly",
    "Have an incident response plan",
    "Educate family about cybersecurity",
    "Keep work and personal devices separate",
    "Don't install unnecessary apps",
    "Read permissions before installing apps",
    "Delete old accounts you don't use",
    "Use disposable email for signups",
    "Clear browser history regularly",
    "Disable auto-fill for sensitive data",
    "Use browser privacy extensions",
    "Block third-party cookies",
    "Disable JavaScript for unknown sites",
    "Avoid public charging stations",
    "Use your own charging cable",
    "Keep software in auto-update mode",
    "Don't jailbreak/root your device",
    "Verify app developers before installing",
    "Check app reviews for security concerns",
    "Use biometric authentication when available",
    "Set up emergency contacts",
    "Have a digital will for accounts",
    "Don't post travel plans publicly",
    "Use a separate credit card for online",
    "Freeze credit when not applying for loans",
    "Check for credit report annually",
    "Use secure password recovery options",
    "Don't use public computers for login",
    "Clear cache after using public computers",
    "Don't write passwords on paper",
    "Use password phrases instead of words",
    "Include special characters in passwords",
    "Don't use personal info in passwords",
    "Change passwords after a breach",
    "Use different passwords for banking",
    "Enable transaction alerts",
    "Verify website security certificates",
    "Don't enter data on non-HTTPS sites",
    "Look for padlock icon in address bar",
    "Don't ignore security warnings",
    "Report suspicious activity immediately",
    "Keep physical devices secure",
    "Don't leave devices in cars",
    "Use tracking software for devices",
    "Backup phone contacts regularly",
    "Enable remote wipe capability",
    "Don't share login credentials",
    "Use company-approved software for work",
    "Follow organizational security policies",
    "Attend security training sessions",
    "Stay informed about new threats",
    "Subscribe to security newsletters",
    "Use ad-blockers to avoid malvertising",
    "Disable macros in Office documents",
    "Don't enable unnecessary browser extensions",
    "Regularly review social media tags",
    "Adjust social media privacy settings",
    "Think before you post online",
    "Assume nothing online is private",
    "Verify information before sharing",
    "Don't participate in online quizzes",
    "Be cautious with QR codes",
    "Scan QR codes with security apps",
  ];

  // Function to get tip
  Future<void> getTip() async {
    setState(() {
      loading = true;
    });

    try {
      // Try API first
      final response = await http.get(
        Uri.parse('https://api.adviceslip.com/advice'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tip = data['slip']['advice'];
        });
      } else {
        // Fallback to local tip
        showLocalTip();
      }
    } catch (e) {
      // Fallback to local tip
      showLocalTip();
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // Show random local tip
  void showLocalTip() {
    final randomIndex = DateTime.now().millisecondsSinceEpoch % cyberTips.length;
    setState(() {
      tip = cyberTips[randomIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyber Tip of the day'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Cyber Security Tips',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // Tip Display
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    if (loading)
                      const CircularProgressIndicator()
                    else
                      Text(
                        tip,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Buttons
              Column(
                children: [
                  ElevatedButton(
                    onPressed: getTip,
                    child: const Text('Get API Tip'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 50),
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: showLocalTip,
                    child: const Text('Get Cyber Tip'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(200, 50),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Stats
              Text(
                'Sir there are no APIs for cyber tips soo ive added it manually soo it wll show both random api tips and cyber tips',
                style: const TextStyle(color: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
