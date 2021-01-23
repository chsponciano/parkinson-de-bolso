import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parkinson_de_bolso/modules/auth/change_password/change_password.dart';
import 'package:parkinson_de_bolso/modules/auth/change_password/redefine_password.dart';
import 'package:parkinson_de_bolso/modules/auth/change_password/verification_code.dart';
import 'package:parkinson_de_bolso/modules/auth/onboarding/onboarding.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_in/sign_in.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_up/sign_up.dart';
import 'package:parkinson_de_bolso/modules/dashboard/dashboard_module.dart';

class _Route {
  final String route;
  final Widget handler;
  final bool logged;

  _Route({@required this.route, @required this.handler, @required this.logged});
}

class RouteHandler {
  RouteHandler._privateConstructor();
  static final RouteHandler instance = RouteHandler._privateConstructor();

  static bool loggedIn;
  static String token;
  final Map routeMap = HashMap<String, _Route>();

  void define(String route, Widget handler, bool logged) {
    routeMap.putIfAbsent(route, () => _Route(route: route, handler: handler, logged: logged));
  }

  RouteFactory exchange() {
    return (settings) {
      _Route route = this.routeMap[settings.name];
      
      if (route.logged && (RouteHandler.token == null || !RouteHandler.loggedIn)) {
        route = this.routeMap[SignIn.routeName];
      }
      
      if (!route.logged && (RouteHandler.token != null && RouteHandler.loggedIn)) {
        route = this.routeMap[DashboardModule.routeName];
      }
      
      return MaterialPageRoute(builder: (BuildContext context) => route.handler);
    };
  }

  static void configureRoutes() {
    RouteHandler route = RouteHandler.instance;
    route.define(Onboarding.routeName, Onboarding(), false);
    route.define(SignIn.routeName, SignIn(), false);
    route.define(SignUp.routeName, SignUp(), false);
    route.define(ChangePassword.routeName, ChangePassword(), false);
    route.define(RedefinePassword.routeName, RedefinePassword(), false);
    route.define(VerificationCode.routeName, VerificationCode(), false);
    route.define(DashboardModule.routeName, DashboardModule(), true);
  }
}
