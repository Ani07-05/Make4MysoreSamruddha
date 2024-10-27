import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setPin(String pin) async {
    await _prefs.setString('pin', pin);
  }

  static Future<String?> getPin() async {
    return _prefs.getString('pin');
  }

  static Future<bool> isPinSet() async {
    return _prefs.containsKey('pin');
  }

  static Future<void> setFirstTimeUser(bool isFirstTime) async {
    await _prefs.setBool('isFirstTimeUser', isFirstTime);
  }

  static Future<bool> isFirstTimeUser() async {
    return _prefs.getBool('isFirstTimeUser') ?? true;
  }

  static Future<void> setVendorType(String vendorType) async {
    await _prefs.setString('vendorType', vendorType);
  }

  static Future<String?> getVendorType() async {
    return _prefs.getString('vendorType');
  }

  static Future<void> setLocaleCode(String localeCode) async {
    await _prefs.setString('locale', localeCode);
  }

  static Future<String> getLocaleCode() async {
    return _prefs.getString('locale') ?? 'en';
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }
}
