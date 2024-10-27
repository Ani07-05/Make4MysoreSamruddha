import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorLocationTracking extends StatefulWidget {
  @override
  _VendorLocationTrackingState createState() => _VendorLocationTrackingState();
}

class _VendorLocationTrackingState extends State<VendorLocationTracking> {
  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  void _startLocationTracking() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      Geolocator.getPositionStream(locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      )).listen((Position position) {
        FirebaseFirestore.instance.collection('vendors').doc('unique_vendor_id').set({
          'latitude': position.latitude,
          'longitude': position.longitude,
        }, SetOptions(merge: true));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vendor Location Tracking', style: Theme.of(context).appBarTheme.titleTextStyle)),
      body: Center(
        child: Text('Location is being tracked and updated.', style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
