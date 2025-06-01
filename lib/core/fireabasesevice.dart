import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

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

    // Get the FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received in foreground: ${message.notification?.title}');
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
  }
}