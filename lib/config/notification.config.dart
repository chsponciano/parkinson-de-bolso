import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parkinson_de_bolso/adapter/notification.adapter.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/service/notify.service.dart';
import 'package:parkinson_de_bolso/type/module.type.dart';
import 'package:parkinson_de_bolso/util/sharedPreferences.util.dart';

class NotificationConfig with SharedPreferencesUtil {
  NotificationConfig._privateConstructor();
  static final NotificationConfig instance =
      NotificationConfig._privateConstructor();
  final NotificationAdpater _notificationAdpater = NotificationAdpater.instance;
  final String _localNotificationListName = env['LOCAL_NOTIFICATION_LIST_NAME'];
  Function _onHandleCounterNotification;
  Timer _notificationTask;

  initialize(BuildContext context, Function onHandleCounterNotification) {
    if (this._notificationTask == null) {
      this._notificationAdpater.initialiaze();
      this._onHandleCounterNotification = onHandleCounterNotification;
      this.getNewNotifications();
      this._startBackgroundProcess();
    }
  }

  dispose() {
    this._notificationTask?.cancel();
    this._notificationTask = null;
  }

  _startBackgroundProcess() {
    print('start background process');
    this._notificationTask = Timer.periodic(
      Duration(
        seconds: int.parse(env['TIME_SEEK_NOTIFICATIONS']),
      ),
      (Timer timer) async => this.getNewNotifications(),
    );
  }

  getNewNotifications() async {
    print('looking for new notifications');
    if (AppConfig.instance.moduleType == ModuleType.DASHBOARD) {
      NotifyService.instance.getAll().then((notifications) async {
        if (notifications != null) {
          List<String> localNotifications = await this.getListPrefs(
            this._localNotificationListName,
          );

          notifications.forEach((notification) {
            if (!localNotifications.contains(notification.id)) {
              this._notificationAdpater.showNotification(notification);
              this.addListPrefs(
                this._localNotificationListName,
                notification.id,
              );
            }
          });

          this._onHandleCounterNotification(notifications.length);
        } else {
          this._onHandleCounterNotification(0);
        }
      });
    }
  }
}
