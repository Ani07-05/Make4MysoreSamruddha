import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:samruddha/localization/app_localizations.dart';
import 'package:samruddha/localization/language_constants.dart';
import 'package:samruddha/screens/role_selection_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/weather_provider.dart';
import 'providers/vegetable_prices_provider.dart';
import 'providers/location_provider.dart';
import 'providers/notification_provider.dart'; // Import NotificationProvider
import 'utils/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SharedPrefs.init();
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en', '');

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    Locale locale = await getLocale();
    setState(() {
      _locale = locale;
    });
  }

  void setLocale(Locale locale) async {
    await setLocaleCode(locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
        ChangeNotifierProvider(create: (context) => VegetablePricesProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()), // Register NotificationProvider
      ],
      child: MaterialApp(
        title: 'Samruddha App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        locale: _locale,
        supportedLocales: [
          Locale('en', ''),
          Locale('kn', ''),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: RoleSelectionScreen(setLocale: setLocale),
      ),
    );
  }
}
