import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parkinson_de_bolso/widget/onboarding.dart';
import 'package:parkinson_de_bolso/widget/signIn.dart';
import 'package:parkinson_de_bolso/widget/signUp.dart';

const homePageRoute = '/onboarding';
const signInRoute = '/signIn';
const signUpRoute = '/signUp';

// RouteFactory loggedInRoutes() {
//   return (settings) {
//     return MaterialPageRoute(builder: (BuildContext context) => Onboarding());
//   };
// }

RouteFactory loggedOutRoutes() {
  return (settings) {
    Widget screen;
    switch(settings.name) {
      case signInRoute:
        screen = SignIn();
        break;
      case signUpRoute:
        screen = SignUp();
        break;
      default:
        screen = Onboarding();
        break;
    }

    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}