import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Key untuk menyimpan token autentikasi dan peran pengguna
  static const _authTokenKey = 'auth_token';
  static const _userRoleKey = 'user_role';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Menyimpan data secara aman
  static Future<void> simpanDataLogin(String token, String role) async {
    await _storage.write(key: _authTokenKey, value: token);
    await _storage.write(key: _userRoleKey, value: role);
  }

  // Menyimpan token dan peran pengguna secara bersamaan
  static Future<String?> getToken() async {
    return await _storage.read(key: _authTokenKey);
  }

  // Mengambil token autentikasi dan peran pengguna yang tersimpan 
  static Future<String?> getRole() async {
    return await _storage.read(key: _userRoleKey);
  }
  
  // Menghapus seluruh data yang tersimpan
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}