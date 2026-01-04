import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  // 32-character key = AES-256
  static final _key = Key.fromUtf8(
      '32characterslongsecretkey!!'
  );

  // 16-character IV
  static final _iv = IV.fromLength(16);

  static final _encrypter = Encrypter(
    AES(_key, mode: AESMode.cbc),
  );

  /// 🔒 Encrypt plain text
  static String encryptText(String text) {
    final encrypted = _encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  /// 🔓 Decrypt encrypted text
  static String decryptText(String encryptedText) {
    final decrypted = _encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}