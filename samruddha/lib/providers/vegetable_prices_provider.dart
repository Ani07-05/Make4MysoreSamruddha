import 'package:flutter/foundation.dart';

class VegetablePrice {
  final String name;
  final double price;

  VegetablePrice({required this.name, required this.price});
}

class VegetablePricesProvider with ChangeNotifier {
  List<VegetablePrice> _prices = [];
  List<VegetablePrice> get prices => _prices;

  Future<void> fetchPrices() async {
    // In a real app, you would fetch this data from an API
    _prices = [
      VegetablePrice(name: 'Potato', price: 20.0),
      VegetablePrice(name: 'Tomato', price: 30.0),
      VegetablePrice(name: 'Onion', price: 25.0),
    ];
    notifyListeners();
  }
}