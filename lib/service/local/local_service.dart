import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String englishLang = 'en';
const String indonesiaLang = 'id';

class LocalService {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'token';

  static IOSOptions _getIOSOptions() => const IOSOptions();

  static AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  static Future setToken(String token) async {
    await _storage.write(
      key: _keyToken,
      value: token,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  static Future<String> getToken() async {
    try {
      String? token = await _storage.read(
        key: _keyToken,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      return token ?? '';
    } catch (e) {
      return "";
    }
  }

  static Future deleteToken() async {
    await _storage.delete(
      key: _keyToken,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }
}
