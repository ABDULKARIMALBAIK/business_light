import 'package:easy_encryption/easy_encryption.dart';

/// Encrypt and decrypt data
class EncryptorService {
  /// Encrypt Data, arguments (plain text), return cipher text
  Future<String> encryptMyMessage(String message) async {
    EasyEncryption easyEncrypt = EasyEncryption();
    String encryptedMessage = await easyEncrypt.encryptData(data: message);
    return encryptedMessage;
  }

  /// Decrypt Data. arguments (cipher text), return plain text
  Future<String> decryptMyMessage(String encryptedMessage) async {
    EasyEncryption easyEncrypt = EasyEncryption();
    String originalMessage =
        await easyEncrypt.decryptData(data: encryptedMessage);
    return originalMessage;
  }
}
