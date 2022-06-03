import 'dart:convert';

import 'package:firebase_notifications_poc/model/firebase_notifiaction_model.dart';
import 'package:firebase_notifications_poc/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHandler {
  static final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  static GlobalKey<NavigatorState>? navigatorKeyState;

  static void initNotification({@required GlobalKey<NavigatorState>? navigatorKey}) {
    navigatorKeyState = navigatorKey;

    var initAndroid = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initIOS = const IOSInitializationSettings(
        /*onDidReceiveLocalNotification: onDidReceiveLocalNotification*/);
    var initSetting = InitializationSettings(android: initAndroid, iOS: initIOS);

    flutterLocalNotificationPlugin.initialize(initSetting, onSelectNotification: onSelectNotification);
  }

  static Future onSelectNotification(String? payload) async {
    if(payload != null) {
      print('Get payload---->>>> $payload');
      try {
        var notificationModel = FirebaseNotificationModel.fromMap(json.decode(payload));
        /*var prefs = await SharedPreferences.getInstance();
        Constants.appTokenValue = prefs.getString(Constants.appTokenKey) ?? '';*/

        switch(notificationModel.type) {
          case 'cart':
            /*if(Constants.appTokenValue.isNotEmpty) {
              if(notificationModel.id != null && notificationModel.id!.isNotEmpty) {
                Navigator.push(navigatorKeyState!.currentState!.context,
                    MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(orderID: int.parse(notificationModel.id!),)
                    ));
              } else {
                Navigator.push(navigatorKeyState!.currentState!.context,
                    MaterialPageRoute(
                        builder: (context) => MyOrdersPage(),)
                    );
              }
            } else {
              Navigator.push(navigatorKeyState!.currentState!.context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage()
                  ));
            }*/
            break;
          case 'ads':
            /*if(notificationModel.id != null && notificationModel.id!.isNotEmpty) {
              Navigator.push(
                  navigatorKeyState!.currentState!.context,
                  MaterialPageRoute(
                      builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(create: (context) => ProductsChangeListTypeNotifier()),
                          ChangeNotifierProvider(create: (context) => ProductsSortOptionNotifier()),
                        ],
                        child: AdProductsPage(adID: int.parse(notificationModel.id!)),
                      )
                  ));
            } else {
              Navigator.push(
                  navigatorKeyState!.currentState!.context,
                  MaterialPageRoute(
                      builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(create: (context) => ProductsChangeListTypeNotifier()),
                          ChangeNotifierProvider(create: (context) => ProductsSortOptionNotifier()),
                        ],
                        child: ProductsPage(subCategoryName: S.of(navigatorKeyState!.currentState!.context).productsLabel),
                      )
                  ));
            }*/
            break;
          case 'general':
          default:

            break;
        }
      } catch(e) {
        print('error---->> $e');
      }
    }
  }
}