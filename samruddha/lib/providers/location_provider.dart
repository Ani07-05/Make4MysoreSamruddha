import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/vendor.dart';

class LocationProvider with ChangeNotifier {
  Position? currentLocation;
  List<Vendor> nearbyVendors = [];

  // Start tracking location for vendor
  Future<void> startLocationTracking() async {
    Geolocator.getPositionStream(locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Track movement over 10 meters
    )).listen((Position position) {
      currentLocation = position;
      updateVendorLocation(position.latitude, position.longitude);
      notifyListeners();
    });
  }

  // Simulate vendor location updates - replace with actual implementation if storing on a backend
  void updateVendorLocation(double latitude, double longitude) {
    // This could involve updating vendor location on backend
    currentLocation = Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      altitude: 0.0,
      accuracy: 1.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 1.0,
      altitudeAccuracy: 1.0,   // Adding required parameter with default value
      headingAccuracy: 1.0      // Adding required parameter with default value
    );
    notifyListeners();
  }

  // Fetch nearby vendors for user
  Future<void> fetchNearbyVendors() async {
    // Simulate fetching nearby vendors. Replace with actual backend call
    nearbyVendors = [
      Vendor(name: 'Vendor 1', type: 'fruits', latitude: currentLocation!.latitude + 0.001, longitude: currentLocation!.longitude + 0.001),
      Vendor(name: 'Vendor 2', type: 'vegetables', latitude: currentLocation!.latitude - 0.001, longitude: currentLocation!.longitude - 0.001),
    ];
    notifyListeners();
  }
}
