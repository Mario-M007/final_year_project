import 'dart:async';
import 'dart:developer';
import 'package:final_year_project/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  // create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch thetoken for this device
    final token = await _firebaseMessaging.getToken();

    // print token
    log('Token: $token');

    // initPushnotifications();
  }

  // function to handle received messages
  void handleNotifications(RemoteMessage? message) {
    // if message is null, do nothing
    if (message == null) return;

    // navigate to notification page with message as argument
    navigatorKey.currentState
        ?.pushNamed('/notification_page', arguments: message);
  }

  Future initPushnotifications() async {
    // handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleNotifications);

    // attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotifications);
  }
}
