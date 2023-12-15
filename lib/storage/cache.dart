import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trustdine/ui_configs.dart';

class SecureStorageManager {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // static const String _keyEmail = 'email';
  static const String _keyToken = 'token';
  static const String _keyPadding = 'padding';

  // Store email and password securely
  static Future<void> saveCredentials(String token) async {
    await _secureStorage.write(key: _keyToken, value: token);
  }

  // Retrieve token from secure storage
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: _keyToken);
  }

  // Delete stored email and password
  static Future<void> deleteToken() async {
    await _secureStorage.delete(key: _keyToken);
  }

  static Future<void> savePadding() async {
    List paddingConfig = [topPad, bottomPad, rightPad, leftPad];
    await _secureStorage.write(
      key: _keyPadding,
      value: paddingConfig.join(","),
    );
  }

  static Future<List?> getPadding() async {
    String? padStr = await _secureStorage.read(key: _keyPadding);
    return padStr!.split(",");
  }
}
