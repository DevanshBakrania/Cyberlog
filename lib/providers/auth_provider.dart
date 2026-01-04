import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthProvider extends ChangeNotifier {
  final LocalAuthentication _auth = LocalAuthentication();

  bool isDecoyMode = false;
  DateTime? lastUnlockTime;

  bool _isUnlocked = false;
  Timer? _autoLockTimer;

  bool get isUnlocked => _isUnlocked;

  // 🔐 Authenticate (Fingerprint / PIN)
  Future<bool> unlockVault() async {
    try {
      final bool isSupported = await _auth.isDeviceSupported();
      if (!isSupported) return false;

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Authenticate to access secure vault',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        _isUnlocked = true;
        _startAutoLockTimer();
        notifyListeners();
      }
      return didAuthenticate;
    } catch (e) {
      debugPrint('Auth error: $e');
      return false;
    }
  }

  // 🔒 Manual lock
  void lock() {
    _isUnlocked = false;
    _autoLockTimer?.cancel();
    notifyListeners();
  }

  // ⏱ Reset timer on user activity
  void resetTimer() {
    if (_isUnlocked) {
      _startAutoLockTimer();
    }
  }

  // ⏲ Auto-lock after 30 seconds
  void _startAutoLockTimer() {
    _autoLockTimer?.cancel();
    _autoLockTimer = Timer(const Duration(seconds: 30), () {
      lock();
    });
  }
}
