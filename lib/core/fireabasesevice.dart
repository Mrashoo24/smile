import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:get/get.dart';

import '../presentation/screens/bookinghistory/bookingController.dart';

/// Top-level function to handle background messages
Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  print('Background message received: ${message.notification?.title}');
}

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeFirebaseMessaging() async {
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not granted permission');
    }
    final iOSToken = await FirebaseMessaging.instance.getAPNSToken();
    if (iOSToken == null) {
      // Error
      return;
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Show a frontend notification
      Get.snackbar(
        'Notification',
        message.notification?.title ?? 'No title',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      var controller = Get.put(BookingController());

      // Call the getBooking API
      await controller.getBookings();
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
  }
}