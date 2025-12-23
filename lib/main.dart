import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('logs');
  await Hive.openBox('checklist');
  await Hive.openBox('settings');

  runApp(const CyberLogApp());
}

class CyberLogApp extends StatelessWidget {
  const CyberLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box('settings');

    return ValueListenableBuilder(
      valueListenable: settingsBox.listenable(),
      builder: (context, box, _) {
        final darkMode = box.get('darkMode', defaultValue: false);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: darkMode ? ThemeData.dark() : ThemeData.light(),
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final screens = const [
    LogsScreen(),
    ChecklistScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: "Logs"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle), label: "Checklist"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final logsBox = Hive.box('logs');
  final controller = TextEditingController();

  void addLog(String status) {
    logsBox.add({
      "action": controller.text,
      "status": status,
      "time": DateTime.now().toString(),
    });
    controller.clear();
  }

  Color statusColor(String status) {
    if (status == "Success") return Colors.green;
    if (status == "Failed") return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cyber Logs")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Log Action",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () => addLog("Success"),
                    child: const Text("Success")),
                ElevatedButton(
                    onPressed: () => addLog("Failed"),
                    child: const Text("Failed")),
                ElevatedButton(
                    onPressed: () => addLog("Blocked"),
                    child: const Text("Blocked")),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ValueListenableBuilder(
                valueListenable: logsBox.listenable(),
                builder: (context, box, _) {
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final log = box.getAt(index);
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.security,
                              color: statusColor(log["status"])),
                          title: Text(log["action"]),
                          subtitle: Text(log["time"]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => box.deleteAt(index),
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
      ),
    );
  }
}

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final checklistBox = Hive.box('checklist');
  final TextEditingController taskController = TextEditingController();

  void addTask() {
    if (taskController.text.trim().isEmpty) return;

    checklistBox.add({
      "task": taskController.text,
      "done": false,
    });

    taskController.clear();
  }

  void toggleTask(int index) {
    final item = checklistBox.getAt(index);
    checklistBox.putAt(index, {
      "task": item["task"],
      "done": !item["done"],
    });
  }

  void deleteTask(int index) {
    checklistBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Checklist")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      labelText: "Enter task",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 32),
                  onPressed: addTask,
                )
              ],
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ValueListenableBuilder(
                valueListenable: checklistBox.listenable(),
                builder: (context, box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text(
                        "No tasks added yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final item = box.getAt(index);

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: item["done"],
                            onChanged: (_) => toggleTask(index),
                          ),
                          title: Text(
                            item["task"],
                            style: TextStyle(
                              decoration: item["done"]
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteTask(index),
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
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box('settings');
    final logsBox = Hive.box('logs');

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: settingsBox.listenable(),
              builder: (context, box, _) {
                return SwitchListTile(
                  title: const Text("Dark Mode"),
                  value: box.get('darkMode', defaultValue: false),
                  onChanged: (value) =>
                      box.put('darkMode', value),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Delete All Logs"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Confirm"),
                    content:
                    const Text("Are you sure you want to delete all logs?"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel")),
                      TextButton(
                        onPressed: () {
                          logsBox.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
