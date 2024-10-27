import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/language_toggle.dart';
import '../widgets/pin_input.dart';
import '../localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../screens/vendor_type_selection_screen.dart';
import '../screens/main_dashboard_screen.dart'; // Updated to include DashboardScreen

class PinEntryScreen extends StatelessWidget {
  final Function(Locale) setLocale;

  PinEntryScreen({required this.setLocale});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              AppLocalizations.of(context)?.translate('enter_pin') ?? 'Enter PIN',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              LanguageToggle(setLocale: setLocale),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)?.translate('enter_your_pin') ?? 'Enter your PIN',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 20),
                PinInput(
                  onPinEntered: (pin) async {
                    bool isAuthenticated = await authProvider.verifyPin(pin);
                    if (isAuthenticated) {
                      bool isFirstTime = await authProvider.isFirstTimeUser();
                      if (isFirstTime) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => VendorTypeSelectionScreen(setLocale: setLocale)),
                        );
                      } else {
                        // Navigate to vendor dashboard with location tracking enabled
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardScreen(
                              setLocale: setLocale,
                              isVendor: true,
                            ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)?.translate('incorrect_pin') ?? 'Incorrect PIN')),
                      );
                    }
                  },
                  textColor: Colors.white,
                  backgroundColor: Colors.grey[900]!,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
