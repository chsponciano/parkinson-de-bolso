import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parkinson_de_bolso/config/app_config.dart';
import 'package:parkinson_de_bolso/modules/auth/change_password/change_password.dart';
import 'package:parkinson_de_bolso/modules/auth/change_password/redefine_password.dart';
import 'package:parkinson_de_bolso/modules/auth/change_password/verification_code.dart';
import 'package:parkinson_de_bolso/modules/auth/onboarding/onboarding.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_in/sign_in.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_up/sign_up.dart';
import 'package:parkinson_de_bolso/modules/dashboard/dashboard_module.dart';
import 'package:parkinson_de_bolso/modules/notification/notification_module.dart';
import 'package:parkinson_de_bolso/util/shared_preferences_util.dart';

class _Route {
  final String route;
  final Widget handler;
  final bool logged;

  _Route({@required this.route, @required this.handler, @required this.logged});
}

class RouteConfig with SharedPreferencesUtil {
  RouteConfig._privateConstructor();
  static final RouteConfig instance = RouteConfig._privateConstructor();
  final AppConfig _appConfig = AppConfig.instance;

  static List arguments = <String>[];
  final Map routeMap = HashMap<String, _Route>();

  void define(String route, Widget handler, bool logged) {
    routeMap.putIfAbsent(
        route, () => _Route(route: route, handler: handler, logged: logged));
  }

  Widget getRoute(String routeName) {
    return routeMap[routeName].handler;
  }

  void exit(context) {
    this.removePrefs('user_email');
    this.removePrefs('user_password');
    this.removePrefs('usage_guidance');
    this._appConfig.loggedInUser = null;
    this._appConfig.session = null;
    this._appConfig.usageGuidance = null;
    Navigator.pushNamed(context, SignIn.routeName);
  }

  RouteFactory exchange() {
    return (settings) {
      _Route route = this.routeMap[settings.name];

      if (route.logged &&
          (this._appConfig.session == null ||
              this._appConfig.loggedInUser == null)) {
        route = this.routeMap[SignIn.routeName];
      }

      if (!route.logged &&
          (this._appConfig.session != null &&
              this._appConfig.loggedInUser != null)) {
        route = this.routeMap[DashboardModule.routeName];
      }

      return MaterialPageRoute(
          builder: (BuildContext context) => route.handler);
    };
  }

  static void configureRoutes() {
    RouteConfig route = RouteConfig.instance;
    route.define(Onboarding.routeName, Onboarding(), false);
    route.define(SignIn.routeName, SignIn(), false);
    route.define(SignUp.routeName, SignUp(), false);
    route.define(ChangePassword.routeName, ChangePassword(), false);
    route.define(RedefinePassword.routeName, RedefinePassword(), false);
    route.define(VerificationCode.routeName, VerificationCode(), false);
    route.define(DashboardModule.routeName, DashboardModule(), true);
    route.define(NotificationModule.routeName, NotificationModule(), true);
  }
}
