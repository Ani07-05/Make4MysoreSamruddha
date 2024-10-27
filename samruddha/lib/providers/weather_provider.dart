import 'package:flutter/foundation.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  Weather? get weather => _weather;

  Future<void> fetchWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      WeatherFactory wf = WeatherFactory("030f4e75991c536b5707a05a1f96ade0");
      Weather w = await wf.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      _weather = w;
      notifyListeners();
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }
}