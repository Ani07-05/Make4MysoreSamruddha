import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samruddha/screens/main_dashboard_screen.dart';
import 'package:samruddha/screens/pin_entry_screen.dart';
import '../providers/notification_provider.dart';

class RoleSelectionScreen extends StatelessWidget {
  final Function(Locale) setLocale;

  RoleSelectionScreen({required this.setLocale});

  void _sendSOS(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.notifyUsers("Alert", "Emergency situation: Please reach out to the vendor ASAP.");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("SOS alert sent to nearby customers.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ಸಮೃದ್ಧ", // "Samruddha" in Kannada
              style: TextStyle(
                fontSize: 60, // Huge font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // Vendor Button
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PinEntryScreen(setLocale: setLocale)), // Go to PIN Entry Page
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text(
                'Vendor',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),
            // User Button
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen(setLocale: setLocale, isVendor: false,)), // Go to User Home Page
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.green, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text(
                'User',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
            SizedBox(height: 20),
            // SOS Button
            OutlinedButton(
              onPressed: () => _sendSOS(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text(
                'SOS',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
