import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final encrypt.Key _key =
  encrypt.Key.fromUtf8('12345678901234567890123456789012');

  static final encrypt.IV _iv =
  encrypt.IV.fromUtf8('1234567890123456');

  static final encrypt.Encrypter _encrypter =
  encrypt.Encrypter(encrypt.AES(_key));

  static String encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decryptText(String encryptedText) {
    return _encrypter.decrypt64(encryptedText, iv: _iv);
  }
}
