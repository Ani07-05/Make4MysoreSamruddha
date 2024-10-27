import 'package:flutter/material.dart';
import '../utils/shared_prefs.dart';

class AuthProvider with ChangeNotifier {
  // Comment out or remove the setPin method if you're hardcoding the PIN
  Future<void> setPin(String pin) async {
    await SharedPrefs.setPin(pin);
    notifyListeners();
  }

  // Hardcoded PIN verification
  Future<bool> verifyPin(String pin) async {
    // Directly check against the hardcoded PIN "2004"
    return pin == '2004';
  }

  Future<bool> isFirstTimeUser() async {
    return await SharedPrefs.isFirstTimeUser();
  }

  Future<void> setFirstTimeUser(bool isFirstTime) async {
    await SharedPrefs.setFirstTimeUser(isFirstTime);
    notifyListeners();
  }

  Future<void> setVendorType(String vendorType) async {
    await SharedPrefs.setVendorType(vendorType);
    notifyListeners();
  }

  Future<String?> getVendorType() async {
    return await SharedPrefs.getVendorType();
  }

  Future<void> logout() async {
    await SharedPrefs.clear();
    notifyListeners();
  }

  Future<bool> isPinSet() async {
    return await SharedPrefs.isPinSet();
  }
}
