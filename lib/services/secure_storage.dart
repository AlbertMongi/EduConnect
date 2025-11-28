import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> setUserEmail(String email) async {
    await _storage.write(key: 'user_email', value: email);
  }

  Future<void> setPassWord(String password) async {
    await _storage.write(key: 'user_password', value: password);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: 'user_email');
  }

  Future<String?> getPassWord() async {
    return await _storage.read(key: 'user_password');
  }
}