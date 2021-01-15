import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';

class HomeScreenAnimation extends StatefulWidget {
  @override
  HomeScreenAnimationState createState() => HomeScreenAnimationState();
}

class HomeScreenAnimationState extends State<HomeScreenAnimation> {
  @override
  Widget build(BuildContext context) {
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
}