import 'package:hive_flutter/hive_flutter.dart';
import 'vault_item.dart';
import 'encryption_service.dart';

class VaultService {
  static late Box<String> _box;

  static Future<void> init() async {
    _box = await Hive.openBox<String>('secureVault');
  }

  static List<VaultItem> getAllItems() {
    return _box.values.map((encryptedValue) {
      final decrypted =
      EncryptionService.decryptText(encryptedValue);

      final parts = decrypted.split('||');

      return VaultItem(
        title: parts.isNotEmpty ? parts[0] : '',
        secret: parts.length > 1 ? parts[1] : '',
      );
    }).toList();
  }
  static Future<void> addItem(String title, String secret) async {
    final encrypted = EncryptionService.encryptText(
      '$title||$secret',
    );
    await _box.add(encrypted);
  }

  static Future<void> deleteItem(int index) async {
    await _box.deleteAt(index);
  }
}
