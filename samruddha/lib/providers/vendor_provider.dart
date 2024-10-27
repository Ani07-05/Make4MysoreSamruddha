import 'package:flutter/material.dart';
import '../utils/shared_prefs.dart';

class VendorTypeProvider with ChangeNotifier {
  String? _vendorType;

  VendorTypeProvider() {
    _loadVendorType();
  }

  String? get vendorType => _vendorType;

  Future<void> setVendorType(String type) async {
    _vendorType = type;
    await SharedPrefs.setVendorType(type);
    notifyListeners();
  }

  Future<void> _loadVendorType() async {
    _vendorType = await SharedPrefs.getVendorType();
    notifyListeners();
  }

  Future<void> clearVendorType() async {
    _vendorType = null;
    await SharedPrefs.clear(); // Clear all preferences
    notifyListeners();
  }
}
