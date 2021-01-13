import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/widget/customFooterButton.dart';
import 'package:parkinson_de_bolso/utilities/route.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  Widget get _illustration {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 50, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/images/onboarding.png'),
            height: 400.0,
          ),
          Text(
            applicationName,
            style: TextStyle(
                color: ternaryColor,
                fontSize: 30.0,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.0
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            caption,
            style: TextStyle(
                color: ternaryColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.0
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(gradient: defaultGradient),
            child: Column(
              children: <Widget>[
                _illustration,
                CustomFooterButton(
                  buttons: [
                    FooterButton(
                      background: ternaryColor,
                      label: titleSignUp,
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
          )),
    );
  }
}
