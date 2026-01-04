import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../vault/vault_service.dart';
import '../vault/vault_item.dart';
import 'vault_gate_screen.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen>
    with WidgetsBindingObserver {

  List<VaultItem> allItems = [];
  List<VaultItem> filteredItems = [];

  final Set<int> _visibleSecrets = {};
  final TextEditingController _searchController =
  TextEditingController();

  Timer? _clipboardTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadItems();
    _searchController.addListener(_filterItems);
  }

  void _loadItems() {
    allItems = VaultService.getAllItems();
    filteredItems = List.from(allItems);
    _visibleSecrets.clear();
    setState(() {});
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredItems = allItems
          .where((item) =>
          item.title.toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleVisibility(int index) {
    context.read<AuthProvider>().resetTimer();
    setState(() {
      _visibleSecrets.contains(index)
          ? _visibleSecrets.remove(index)
          : _visibleSecrets.add(index);
    });
  }

  Future<void> _copySecret(String secret) async {
    context.read<AuthProvider>().resetTimer();

    await Clipboard.setData(ClipboardData(text: secret));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Secret copied! Clipboard will clear in 20 seconds',
        ),
        duration: Duration(seconds: 3),
      ),
    );

    _clipboardTimer?.cancel();
    _clipboardTimer = Timer(const Duration(seconds: 20), () {
      Clipboard.setData(const ClipboardData(text: ''));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      context.read<AuthProvider>().lock();
    }
  }

  @override
  void dispose() {
    _clipboardTimer?.cancel();
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _addSecret() {
    final titleController = TextEditingController();
    final secretController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Secret'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration:
              const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: secretController,
              decoration:
              const InputDecoration(labelText: 'Secret'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await VaultService.addItem(
                titleController.text,
                secretController.text,
              );
              Navigator.pop(context);
              _loadItems();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isUnlocked) {
      return const VaultGateScreen();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.read<AuthProvider>().resetTimer(),
      child: Scaffold(
        backgroundColor: const Color(0xFF020617),
        appBar: AppBar(
          title: const Text('Secure Vault'),
          backgroundColor: const Color(0xFF020617),
          actions: [
            IconButton(
              icon: const Icon(Icons.lock),
              onPressed: () {
                context.read<AuthProvider>().lock();
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addSecret,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search secrets...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child: filteredItems.isEmpty
                  ? const Center(
                child: Text(
                  'No secrets found',
                  style:
                  TextStyle(color: Colors.white70),
                ),
              )
                  : ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final isVisible =
                  _visibleSecrets.contains(index);

                  return Card(
                    color: const Color(0xFF0F172A),
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        item.title,
                        style: const TextStyle(
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        isVisible
                            ? item.secret
                            : '••••••••••••',
                        style: const TextStyle(
                            color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.cyanAccent,
                            ),
                            onPressed: () =>
                                _toggleVisibility(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy,
                                color:
                                Colors.greenAccent),
                            onPressed: () =>
                                _copySecret(item.secret),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () async {
                              await VaultService
                                  .deleteItem(index);
                              _loadItems();
                            },
                          ),
                        ],
                      ),
                    ),
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
