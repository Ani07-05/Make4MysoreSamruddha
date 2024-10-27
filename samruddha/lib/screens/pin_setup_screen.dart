import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/language_toggle.dart';
import '../widgets/pin_input.dart';
import '../localization/app_localizations.dart';
import '../providers/auth_provider.dart';
import 'pin_entry_screen.dart';

class PinSetupScreen extends StatelessWidget {
  final Function(Locale) setLocale;

  PinSetupScreen({required this.setLocale});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              AppLocalizations.of(context)?.translate('setup_pin') ?? 'Setup PIN',
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
                  AppLocalizations.of(context)?.translate('enter_new_pin') ?? 'Enter new PIN',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 20),
                PinInput(
                  onPinEntered: (pin) async {
                    await authProvider.setPin(pin);
                    await authProvider.setFirstTimeUser(false);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => PinEntryScreen(setLocale: setLocale)),
                    );
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
