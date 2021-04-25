import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.changePassword.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.onboarding.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.redefinePassword.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.signIn.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.signUp.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.verification.page.dart';

RouteFactory authRoutes() {
  return (settings) {
    // final Map<String, dynamic> arguments = settings.arguments;

    Widget screen;
    switch (settings.name) {
      case SignInPage.routeName:
        screen = SignInPage();
        break;
      case SignUpPage.routeName:
        screen = SignUpPage();
        break;
      case OnboardingPage.routeName:
        screen = OnboardingPage();
        break;
      case ChangePasswordPage.routeName:
        screen = ChangePasswordPage();
        break;
      case RedefinePasswordPage.routeName:
        screen = RedefinePasswordPage();
        break;
      case VerificationCodePage.routeName:
        screen = VerificationCodePage();
        break;
      default:
        screen = SignInPage();
        break;
    }

    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}
