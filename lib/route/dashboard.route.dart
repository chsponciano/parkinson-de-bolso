import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/modules/dashboard/action/dashboard.actions.dart';
import 'package:parkinson_de_bolso/modules/dashboard/navagation/dashboard.navegation.dart';
import 'package:parkinson_de_bolso/modules/dashboard/notification/notification.page.dart';
import 'package:parkinson_de_bolso/type/module.type.dart';
import 'package:parkinson_de_bolso/util/sharedPreferences.util.dart';

class DashboardRoutes with SharedPreferencesUtil {
  DashboardRoutes._privateConstructor();
  static final DashboardRoutes instance = DashboardRoutes._privateConstructor();
  final AppConfig _config = AppConfig.instance;
  Function _changeNavegationIndexFunction;

  setChangeNavegationIndexFunction(Function f) {
    this._changeNavegationIndexFunction = f;
  }

  RouteFactory getRoutes() {
    return (settings) {
      // final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case NotificationPage.routeName:
          screen = NotificationPage();
          break;
        case DashboardNavegation.routeName:
          screen = DashboardNavegation();
          break;
      }

      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }

  setRouteNavagtion(int index) {
    var actions = DashboardActions.instance;
    switch (index) {
      case 0:
        actions.setPatientListRoute();
        break;
      case 1:
        actions.setReportRoute();
        break;
      case 2:
        actions.setSettingRoute();
        break;
    }

    this._changeNavegationIndexFunction(index);
  }

  logout() {
    this.removePrefs('user_email');
    this.removePrefs('user_password');
    this.removePrefs('usage_guidance');
    this._config.loggedInUser = null;
    this._config.session = null;
    this._config.usageGuidance = null;
    this._config.changeModule(ModuleType.AUTH, null, null, null);
  }
}
