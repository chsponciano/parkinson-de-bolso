import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/notification_config.dart';
import 'package:parkinson_de_bolso/config/theme_config.dart';
import 'package:parkinson_de_bolso/modules/notification/notification_module.dart';

class CustomButtomNotification extends StatefulWidget {
  @override
  _CustomButtomNotificationState createState() =>
      _CustomButtomNotificationState();
}

class _CustomButtomNotificationState extends State<CustomButtomNotification> {
  int _numberActiveNotifications;

  @override
  void initState() {
    this._numberActiveNotifications = 0;
    NotificationConfig.instance.onCounterIcon.add(setNumberActiveNotifications);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        child: Stack(
          children: [
            Icon(
              Icons.notifications,
              color: ThemeConfig.ternaryColor,
              size: 30,
            ),
            if (this._numberActiveNotifications > 0)
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: ThemeConfig.secondaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      border: Border.all(
                        color: ThemeConfig.secondaryColor,
                        width: 1,
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(
                      0.0,
                    ),
                    child: Center(
                      child: Text(
                        this._numberActiveNotifications.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: ThemeConfig.ternaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      onPressed: () => Navigator.pushNamed(
        context,
        NotificationModule.routeName,
      ),
    );
  }

  setNumberActiveNotifications(int n) {
    this.setState(
      () => this._numberActiveNotifications = n,
    );
  }
}
