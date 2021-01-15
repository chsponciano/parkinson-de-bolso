import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/utilities/route.dart';
import 'package:parkinson_de_bolso/widget/customScaffold.dart';
import 'package:parkinson_de_bolso/widget/customFooterButton.dart';
import 'package:parkinson_de_bolso/widget/homeScreenAnimation.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: defaultGradient),
        child: Column(
          children: <Widget>[
            HomeScreenAnimation(),
            CustomFooterButton(
              buttons: [
                FooterButton(
                  background: ternaryColor,
                  label: titleSignIn,
                  onPressed: () => Navigator.pushNamed(context, signInRoute),
                ),
                FooterButton(
                  background: ternaryColor,
                  label: titleSignUp,
                  onPressed: () => Navigator.pushNamed(context, signUpRoute),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
