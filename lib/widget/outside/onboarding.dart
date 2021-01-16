import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/widget/customized/customized.dart';
import 'package:parkinson_de_bolso/widget/outside/homeScreenAnimation.dart';
import 'package:parkinson_de_bolso/widget/outside/signIn.dart';
import 'package:parkinson_de_bolso/widget/outside/signUp.dart';
import 'package:parkinson_de_bolso/widget/own/footerButton.dart';

class Onboarding extends StatelessWidget {
  Function loginAction;

  Onboarding({ this.loginAction }):
    assert(loginAction != null);

  @override
  Widget build(BuildContext context) {
    return PbScaffold(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: defaultGradient),
        child: Column(
          children: <Widget>[
            HomeScreenAnimation(),
            FooterGroupButton(
              buttons: [
                FooterButton(
                  background: ternaryColor,
                  label: titleSignIn,
                  onPressed: () => Navigator.pushNamed(context, SignIn.routeName, arguments: SignInArguments(loginAction: this.loginAction)),
                ),
                FooterButton(
                  background: ternaryColor,
                  label: titleSignUp,
                  onPressed: () => Navigator.pushNamed(context, SignUp.routeName),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
