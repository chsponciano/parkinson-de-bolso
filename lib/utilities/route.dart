import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parkinson_de_bolso/main.dart';
import 'package:parkinson_de_bolso/widget/outside/changePassword.dart';
import 'package:parkinson_de_bolso/widget/outside/redefinePassword.dart';
import 'package:parkinson_de_bolso/widget/outside/signIn.dart';
import 'package:parkinson_de_bolso/widget/outside/signUp.dart';
import 'package:parkinson_de_bolso/widget/outside/verificationCode.dart';

// RouteFactory loggedInRoutes() {
//   return (settings) {
//     return MaterialPageRoute(builder: (BuildContext context) => Onboarding());
//   };
// }

RouteFactory loggedOutRoutes() {
  return (settings) {
    Widget screen;
    switch(settings.name) {
      case SignIn.routeName:
        final SignInArguments args = settings.arguments;
        screen = SignIn(loginAction: args.loginAction);
        break;
      case SignUp.routeName:
        screen = SignUp();
        break;
      case RedefinePassword.routeName:
        screen = RedefinePassword();
        break;
      case VerificationCode.routeName:
        screen = VerificationCode();
        break;
      case ChangePassword.routeName:
        screen = ChangePassword();
        break;
      default:
        screen = App();
        break;
    }

    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}