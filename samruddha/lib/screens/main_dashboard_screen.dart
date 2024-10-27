import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/language_toggle.dart';
import '../localization/app_localizations.dart';
import '../providers/weather_provider.dart';
import '../providers/vegetable_prices_provider.dart';
import '../providers/notification_provider.dart';

class DashboardScreen extends StatefulWidget {
  final Function(Locale) setLocale;
  final bool isVendor;

  DashboardScreen({required this.setLocale, required this.isVendor});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _locationGranted = false;
  double _temperature = 27.0;
  Timer? _timer;
  Position? _currentPosition;

  final List<Map<String, dynamic>> _perishableItems = [
    {'name': 'banana', 'discount': 20},
    {'name': 'orange', 'discount': 25},
    {'name': 'tomato', 'discount': 30},
    {'name': 'spinach', 'discount': 15},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchVegetablePrices();
    });

    _checkLocationPermission();
    _startTemperatureFluctuation();
    if (!widget.isVendor) {
      _determinePosition();
    }
  }

  Future<void> _fetchVegetablePrices() async {
    try {
      final vegetablePricesProvider = Provider.of<VegetablePricesProvider>(context, listen: false);
      await vegetablePricesProvider.fetchPrices();
      setState(() {});
    } catch (e) {
      print("Error fetching vegetable prices: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTemperatureFluctuation() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _temperature = _temperature == 27.0 ? 30.0 : 27.0;
      });
    });
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    setState(() {
      _locationGranted = permission == LocationPermission.whileInUse || permission == LocationPermission.always;
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {});
  }

  void _notifyPerishableItem(String itemName, double discount) {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.notifyUsers(
      "$itemName at $discount% off!",
      "Get $itemName at a $discount% discount before it expires!",
    );
  }

  void _sendSOS(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.notifyUsers("Alert", "Emergency situation: Please reach out to the vendor ASAP.");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("SOS alert sent to nearby customers.")),
    );
  }

  Widget _getWeatherIcon() {
    return Icon(
      Icons.wb_sunny,
      color: _temperature == 30.0 ? Colors.orange : Colors.blueAccent,
      size: 40,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vegetablePricesProvider = Provider.of<VegetablePricesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            "Samruddha",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        actions: [
          LanguageToggle(setLocale: widget.setLocale),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isVendor)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: _checkLocationPermission,
                  child: Text(
                    'PushKart Location',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            if (!widget.isVendor)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          'Mock Map',
                          style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_currentPosition != null)
                        Positioned(
                          left: 150,
                          top: 130,
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            if (_currentPosition != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)?.translate('vegetable_prices') ?? 'Vegetable Prices',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: vegetablePricesProvider.prices.map((price) {
                String vegetableName = AppLocalizations.of(context)?.translate(price.name.toLowerCase()) ?? price.name;
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          '$vegetableName: ₹${price.price}/kg',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (_locationGranted)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.grey[900],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        _getWeatherIcon(),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.translate('current_weather') ?? 'Current Weather',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${AppLocalizations.of(context)?.translate('degree_celsius') ?? 'Degree Celsius'}: ${_temperature.toStringAsFixed(1)}°C',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (widget.isVendor)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.translate('perishable_items') ?? 'Perishable Items',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: _perishableItems.map((item) {
                        return Card(
                          color: Colors.grey[850],
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)?.translate(item['name'])} (${item['name']})",
                                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${item['discount']}% ${AppLocalizations.of(context)?.translate('discount') ?? 'Discount'}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _notifyPerishableItem(item['name'], item['discount']);
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                  child: Text(
                                    AppLocalizations.of(context)?.translate('notify') ?? 'Notify',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: widget.isVendor
          ? FloatingActionButton(
              onPressed: () => _sendSOS(context),
              backgroundColor: Colors.red,
              child: Icon(Icons.sos, color: Colors.white),
            )
          : null,
    );
  }
}
