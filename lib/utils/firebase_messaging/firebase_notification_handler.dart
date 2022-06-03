import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notifications_poc/main.dart';
import 'package:firebase_notifications_poc/utils/constants.dart';
import 'package:firebase_notifications_poc/utils/firebase_messaging/notification_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
}*/

class FirebaseNotifications {
  static late FirebaseMessaging _messaging;

  static setUpFirebase() {
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(navigatorKey: MyApp.navigatorKey);
    firebaseCloudMessagingListener();
  }

  static firebaseCloudMessagingListener() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true
    );

    print('Setting ${settings.authorizationStatus}');

    //Get token
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _messaging.onTokenRefresh.listen((token) {
      prefs.setString(Constants.firebaseTokenKey, token);
      Constants.firebaseTokenValue = token;
      print('Firebase refreshed token: $token');
    });

    _messaging.getToken().then((token) {
      prefs.setString(Constants.firebaseTokenKey, token ?? '');
      Constants.firebaseTokenValue = token ?? '';
      print('Firebase token: $token');
    });


    // When app is in Foreground
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      RemoteNotification? data = remoteMessage.notification;
      if(Platform.isAndroid) {
        showNotification(title: data?.title, body: data?.body, payload: remoteMessage.data);
      } else if(Platform.isIOS) {
        showNotification(title: data?.title, body: data?.body, payload: remoteMessage.data);
      }
    });

    // When app is in background but opened and the user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      print('Receive open app: $remoteMessage');

      if (remoteMessage.data != null && remoteMessage.data.isNotEmpty) {
        showNotification(title: remoteMessage.notification?.title ?? '', body: remoteMessage.notification?.body ?? '', payload: remoteMessage.data);
      } else{
        showNotification(title: remoteMessage.notification?.title ?? '', body: remoteMessage.notification?.body ?? '');
      }
    });
  }

  static Future<void> showNotification({String? title, String? body, Map? payload}) async {
    try {
      var androidChannel = AndroidNotificationDetails(
          Constants.androidFCMChannelID, Constants.androidFCMChannelName,
          channelDescription: Constants.androidFCMChannelDescription,
          autoCancel: true, ongoing: false, importance: Importance.max,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
          vibrationPattern: Int64List.fromList([100, 200, 300, 400, 500, 400, 300, 200, 400]),
          priority: Priority.high);

      var ios = IOSNotificationDetails();

      var platform = NotificationDetails(android: androidChannel, iOS: ios);

      await NotificationHandler.flutterLocalNotificationPlugin
          .show(Random().nextInt(1000), title, body, platform, payload: payload.toString());
    } on Exception catch (e) {
      print('Error---->>>> $e');
    }
  }
}