import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  static final _key = Key.fromUtf8(
      '32characterslongsecretkey!!'
  );
  
  static final _iv = IV.fromLength(16);

  static final _encrypter = Encrypter(
    AES(_key, mode: AESMode.cbc),
  );

  static String encryptText(String text) {
    final encrypted = _encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  static String decryptText(String encryptedText) {
    final decrypted = _encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}
