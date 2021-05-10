import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:parkinson_de_bolso/model/receivedNotification.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/notification/notification.dash.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io' show Platform;

class NotificationAdpater {
  NotificationAdpater._privateConstructor();
  static final NotificationAdpater instance =
      NotificationAdpater._privateConstructor();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotificationModel>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotificationModel>();
  var initializationSettings;

  initialiaze() async {
    this.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      this._requestIOSPermission();
    }

    this._initializePlatformSpecifics();
  }

  _initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceivedNotificationModel receivedNotification =
              ReceivedNotificationModel(
            notificationid: id,
            title: title,
            body: body,
            payload: payload,
          );
          didReceivedLocalNotificationSubject.add(receivedNotification);
        });
    this.initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
  }

  setOnNotificationClick(BuildContext context, Function onNotificationClick) {
    this.flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      await Navigator.pushNamed(context, NotificationDash.routeName);
    });
  }

  _requestIOSPermission() {
    this
        .flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification(
    ReceivedNotificationModel notification,
    int id,
  ) async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      androidChannelSpecifics,
      iosChannelSpecifics,
    );
    await this.flutterLocalNotificationsPlugin.show(
          id,
          notification.title,
          notification.body,
          platformChannelSpecifics,
          payload: notification.payload,
        );
  }
}
