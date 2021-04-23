import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parkinson_de_bolso/modules/notification/notification_module.dart';
import 'package:parkinson_de_bolso/plugin/notification_plugin.dart';
import 'package:parkinson_de_bolso/service/notify_service.dart';
import 'package:parkinson_de_bolso/util/shared_preferences_util.dart';

class NotificationConfig with SharedPreferencesUtil {
  NotificationConfig._privateConstructor();
  static final NotificationConfig instance =
      NotificationConfig._privateConstructor();
  final String _localNotificationListName = env['LOCAL_NOTIFICATION_LIST_NAME'];
  final List<Function> onCounterIcon = <Function>[];
  Timer _notificationTask;

  initialize(BuildContext context) {
    if (this._notificationTask == null) {
      notificationPlugin.setOnNotificationClick(
          context, this.onNotificationClick);
      this._getNewNotifications();
      this._startBackgroundProcess();
    }
  }

  dispose() {
    this._notificationTask?.cancel();
  }

  onNotificationClick(BuildContext context, String payload) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return NotificationModule(
            payload: payload,
          );
        },
      ),
    );
  }

  _startBackgroundProcess() {
    print('start background process');
    this._notificationTask = Timer.periodic(
      Duration(
        seconds: int.parse(env['TIME_SEEK_NOTIFICATIONS']),
      ),
      (Timer timer) async => this._getNewNotifications(),
    );
  }

  _getNewNotifications() async {
    print('looking for new notifications');
    NotifyService.instance.getAll().then((notifications) async {
      if (notifications != null) {
        List<String> localNotifications =
            await this.getListPrefs(this._localNotificationListName);
        notifications.forEach((notification) {
          if (!localNotifications.contains(notification.id)) {
            notificationPlugin.showNotification(notification);
            this.addListPrefs(this._localNotificationListName, notification.id);
          }
        });

        this._handleOnCounterIcon(notifications.length);
      } else {
        this._handleOnCounterIcon(0);
      }
    });
  }

  _handleOnCounterIcon(int value) {
    this.onCounterIcon.forEach((f) => f(value));
  }
}
