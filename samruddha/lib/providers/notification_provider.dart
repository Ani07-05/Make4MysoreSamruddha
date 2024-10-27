// lib/providers/notification_provider.dart

import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  void notifyNearestCustomers(String title, String message) {
    // Logic to notify nearest customers based on your backend or notification service.
    print("Notification sent to nearest customers: $title - $message");
  }

  void notifyUsers(String title, String message) {
    // Logic to notify users based on your backend or notification service.
    print("Notification sent to users: $title - $message");
  }
}
