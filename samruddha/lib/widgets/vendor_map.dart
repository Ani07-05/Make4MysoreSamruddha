import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/vendor.dart';

class VendorMap extends StatelessWidget {
  final List<Vendor> vendors;

  VendorMap({required this.vendors});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(vendors[0].latitude, vendors[0].longitude),
          zoom: 15,
        ),
        markers: vendors.map((vendor) {
          return Marker(
            markerId: MarkerId(vendor.name),
            position: LatLng(vendor.latitude, vendor.longitude),
            infoWindow: InfoWindow(
              title: vendor.name,
              snippet: vendor.type,
            ),
          );
        }).toSet(),
      ),
    );
  }
}
