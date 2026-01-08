import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('logs'); 
  await Hive.openBox('settings'); 

  final prefs = await SharedPreferences.getInstance();
  final bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(CyberLogApp(initialDarkMode: isDarkMode));
}
class CyberLogApp extends StatefulWidget {
  final bool initialDarkMode;
  const CyberLogApp({super.key, required this.initialDarkMode});

  @override
  State<CyberLogApp> createState() => _CyberLogAppState();
}

class _CyberLogAppState extends State<CyberLogApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.initialDarkMode;
  }

  void toggleTheme(bool value) async {
    setState(() => isDarkMode = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomeScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: toggleTheme,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  const HomeScreen({super.key, required this.isDarkMode, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final logsBox = Hive.box('logs');
  final settingsBox = Hive.box('settings');
  String defaultStatus = 'Success';

  @override
  void initState() {
    super.initState();
    defaultStatus = settingsBox.get('defaultStatus', defaultValue: 'Success');
  }

  int getTotalLogs() => logsBox.length;

  void addLog(String status) {
    logsBox.add({'status': status, 'time': DateTime.now().toString()});
    setState(() {}); 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added log with status: $status')),
    );
  }

  void clearLogs() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Clear Logs'),
        content: const Text('Are you sure you want to delete all logs?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                logsBox.clear();
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Clear', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentLogs = logsBox.values.toList().reversed.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CyberLog Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                      isDarkMode: widget.isDarkMode,
                      onThemeChanged: widget.onThemeChanged),
                ),
              ).then((_) {
                setState(() {
                  defaultStatus = settingsBox.get('defaultStatus', defaultValue: 'Success');
                });
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statCard('Total Logs', getTotalLogs().toString(), Colors.blue),
                _statCard('Default Status', defaultStatus, Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recent Logs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: recentLogs.isEmpty
                        ? const Center(child: Text('No logs yet'))
                        : ListView.builder(
                      itemCount: recentLogs.length,
                      itemBuilder: (context, index) {
                        final rawLog = recentLogs[index];
                        Map log;
                        if (rawLog is Map) {
                          log = Map.from(rawLog);
                        } else if (rawLog is String) {
                          log = {'status': rawLog, 'time': ''};
                        } else {
                          log = {'status': 'Unknown', 'time': ''};
                        }

                        Color color = Colors.grey;
                        if (log['status'] == 'Success') color = Colors.green;
                        if (log['status'] == 'Failed') color = Colors.red;
                        if (log['status'] == 'Blocked') color = Colors.orange;

                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.circle, color: color),
                            title: Text(log['status']),
                            subtitle: Text(log['time']),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => addLog(defaultStatus),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Log'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      color: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 150,
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SettingsScreen({super.key, required this.isDarkMode, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const MethodChannel _channel = MethodChannel('cyberlog/device');
  final settingsBox = Hive.box('settings');

  String deviceModel = 'Loading...';
  String androidVersion = 'Loading...';
  bool isLoading = true;

  String defaultStatus = 'Success';
  final List<String> statuses = ['Success', 'Failed', 'Blocked'];

  Map<String, PermissionStatus> permissions = {
    'Camera': PermissionStatus.denied,
    'Storage': PermissionStatus.denied,
    'Location': PermissionStatus.denied,
  };

  @override
  void initState() {
    super.initState();
    defaultStatus = settingsBox.get('defaultStatus', defaultValue: 'Success');
    fetchDeviceInfo();
    checkPermissions();
  }

  Future<void> fetchDeviceInfo() async {
    try {
      final model = await _channel.invokeMethod<String>('getDeviceModel');
      final version = await _channel.invokeMethod<String>('getAndroidVersion');

      setState(() {
        deviceModel = model ?? 'Unknown';
        androidVersion = version ?? 'Unknown';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        deviceModel = 'Unavailable';
        androidVersion = 'Unavailable';
        isLoading = false;
      });
    }
  }

  Future<void> checkPermissions() async {
    permissions['Camera'] = await Permission.camera.status;
    permissions['Storage'] = await Permission.storage.status;
    permissions['Location'] = await Permission.location.status;
    setState(() {});
  }

  void saveDefaultStatus(String status) {
    setState(() => defaultStatus = status);
    settingsBox.put('defaultStatus', status);
  }

  void clearLogs() async {
    final logsBox = Hive.box('logs');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Clear Logs'),
        content: const Text('Are you sure you want to delete all logs?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                logsBox.clear();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All logs cleared!')),
                );
              },
              child: const Text('Clear', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  Widget permissionTile(String name, PermissionStatus status) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          status.isGranted ? Icons.check_circle : Icons.cancel,
          color: status.isGranted ? Colors.green : Colors.red,
        ),
        title: Text(name),
        subtitle: Text(status.toString().split('.').last),
      ),
    );
  }

  Widget settingsTile(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            settingsTile('Device Model', deviceModel, Icons.phone_android),
            const SizedBox(height: 12),
            settingsTile('Android Version', androidVersion, Icons.android),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: SwitchListTile(
                title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                secondary: const Icon(Icons.dark_mode, color: Colors.blue),
                value: widget.isDarkMode,
                onChanged: widget.onThemeChanged,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                leading: const Icon(Icons.list_alt, color: Colors.blue),
                title: const Text('Default Log Status', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: DropdownButton<String>(
                  value: defaultStatus,
                  items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (value) {
                    if (value != null) saveDefaultStatus(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Permissions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ...permissions.entries.map((e) => permissionTile(e.key, e.value)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: clearLogs,
              icon: const Icon(Icons.delete),
              label: const Text('Clear Logs'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            const SizedBox(height: 20),
            const Text('App Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            const Text('CyberLog v1.0.0'),
            const Text('Build: 1.0.0'),
            const Text('Developer: Devansh'),
          ],
        ),
      ),
    );
  }
}
