import 'package:flutter/material.dart';
import '../localization/language_constants.dart';

class LanguageToggle extends StatelessWidget {
  final Function(Locale) setLocale;

  LanguageToggle({required this.setLocale});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.language),
      onPressed: () {
        Locale currentLocale = Localizations.localeOf(context);
        if (currentLocale.languageCode == 'en') {
          setLocale(Locale('kn', ''));
        } else {
          setLocale(Locale('en', ''));
        }
      },
    );
  }
}
