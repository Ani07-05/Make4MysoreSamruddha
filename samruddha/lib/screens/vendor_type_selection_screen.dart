import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/language_toggle.dart';
import '../localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../screens/main_dashboard_screen.dart';

class VendorTypeSelectionScreen extends StatelessWidget {
  final Function(Locale) setLocale;

  VendorTypeSelectionScreen({required this.setLocale});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('vendor_type_selection') ?? 'Vendor Type Selection'),
        actions: [
          LanguageToggle(setLocale: setLocale),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            VendorTypeButton(
              title: AppLocalizations.of(context)!.translate('fruits') ?? 'Fruits',
              onPressed: () => _selectVendorType(context, authProvider, 'fruits'),
            ),
            SizedBox(height: 20),
            VendorTypeButton(
              title: AppLocalizations.of(context)!.translate('vegetables') ?? 'Vegetables',
              onPressed: () => _selectVendorType(context, authProvider, 'vegetables'),
            ),
            SizedBox(height: 20),
            VendorTypeButton(
              title: AppLocalizations.of(context)!.translate('novelties') ?? 'Novelties',
              onPressed: () => _selectVendorType(context, authProvider, 'novelties'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectVendorType(BuildContext context, AuthProvider authProvider, String vendorType) async {
    await authProvider.setVendorType(vendorType);
    await authProvider.setFirstTimeUser(false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen(setLocale: setLocale, isVendor: true)), // Pass `true` for `isVendor`
    );
  }
}

class VendorTypeButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const VendorTypeButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
