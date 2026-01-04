import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'vault_screen.dart';

class VaultGateScreen extends StatelessWidget {
  const VaultGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isUnlocked) {
      return const VaultScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.lock_open),
          label: const Text('Unlock Vault'),
          onPressed: () async {
            final success =
            await context.read<AuthProvider>().unlockVault();

            if (!success && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Authentication failed'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
