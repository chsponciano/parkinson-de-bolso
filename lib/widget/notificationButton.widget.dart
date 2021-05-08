import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/dash.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/modules/dashboard/notification/notification.dash.dart';
import 'package:parkinson_de_bolso/type/module.type.dart';

class NotificationButtonWidget extends StatelessWidget {
  final int numberActiveNotifications;
  final Color color;

  const NotificationButtonWidget({
    Key key,
    this.numberActiveNotifications,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        child: Stack(
          children: [
            Icon(
              Icons.notifications,
              color: this.color,
              size: 30,
            ),
            if (this.numberActiveNotifications > 0)
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
                        this.numberActiveNotifications.toString(),
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
      onPressed: () {
        AppConfig.instance.changeModule(ModuleType.NOTIFICATION);
        Navigator.pushNamed(
          DashConfig.instance.getContext(),
          NotificationDash.routeName,
        );
      },
    );
  }
}
