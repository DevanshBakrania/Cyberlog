import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticateUser() async {
    try {
      final bool isSupported = await _auth.isDeviceSupported();
      if (!isSupported) return false;

      return await _auth.authenticate(
        localizedReason: 'Unlock Secure Vault',
        options: const AuthenticationOptions(
          biometricOnly: false, // ✅ REQUIRED
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      print('Biometric error: ${e.code}');
      return false;
    }
  }
}