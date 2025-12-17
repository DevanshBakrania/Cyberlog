import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LogProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class Log {
  final String action;
  final DateTime time;
  final String status;

  Log(this.action, this.time, this.status);
}

class LogProvider extends ChangeNotifier {
  final List<Log> _logs = [];

  List<Log> get logs => _logs;

  void addLog(String action, String status) {
    _logs.add(Log(action, DateTime.now(), status));
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }
}

class SettingsProvider extends ChangeNotifier {
  bool isDarkMode = false;
  String defaultStatus = "Success";

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void setDefaultStatus(String status) {
    defaultStatus = status;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CyberLog',
          theme: ThemeData(
            brightness:
            settings.isDarkMode ? Brightness.dark : Brightness.light,
            useMaterial3: true,
          ),
          home: const CyberLogScreen(),
        );
      },
    );
  }
}

class CyberLogScreen extends StatefulWidget {
  const CyberLogScreen({super.key});

  @override
  State<CyberLogScreen> createState() => _CyberLogScreenState();
}

class _CyberLogScreenState extends State<CyberLogScreen> {
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("CyberLog Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SettingsScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<LogProvider>(context, listen: false).clearLogs();
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["Success", "Failed", "Blocked"].map((status) {
                final isSelected = selectedStatus == status;
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedStatus = status;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.blue : Colors.grey),
                  child: Text(status),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: Consumer<LogProvider>(
              builder: (context, logProvider, child) {
                if (logProvider.logs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No logs available",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: logProvider.logs.length,
                  itemBuilder: (context, index) {
                    final log = logProvider.logs[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.security),
                        title: Text(log.action),
                        subtitle: Text(
                            "${log.status} • ${log.time.hour}:${log.time.minute.toString().padLeft(2, '0')}"),
                        trailing: Icon(
                          log.status == "Success"
                              ? Icons.check_circle
                              : log.status == "Blocked"
                              ? Icons.block
                              : Icons.error,
                          color: log.status == "Success"
                              ? Colors.lightGreen
                              : log.status == "Blocked"
                              ? Colors.orangeAccent
                              : Colors.redAccent
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final logStatus =
              selectedStatus ?? settings.defaultStatus;
          Provider.of<LogProvider>(context, listen: false)
              .addLog("Security Scan", logStatus);
          setState(() {
            selectedStatus = null;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: settings.isDarkMode,
              onChanged: (_) => settings.toggleTheme(),
            ),
            const SizedBox(height: 20),
            const Text("Default Status", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["Success", "Failed", "Blocked"].map((status) {
                final isSelected = settings.defaultStatus == status;
                return ElevatedButton(
                  onPressed: () => settings.setDefaultStatus(status),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.blue : Colors.grey),
                  child: Text(status),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
