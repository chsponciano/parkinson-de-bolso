import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/utilities/route.dart';
import 'package:parkinson_de_bolso/widget/outside/onboarding.dart';

// ignore: must_be_immutable
class OutsideApp extends StatelessWidget {
  Function loginAction;

  OutsideApp({ this.loginAction }):
    assert(loginAction != null);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: applicationName,
      theme: ThemeData(
        fontFamily: defaultFont
      ),
      debugShowCheckedModeBanner: false,
      home: Onboarding(
        loginAction: loginAction
      ),
      onGenerateRoute: loggedOutRoutes(),
    );
  }

}