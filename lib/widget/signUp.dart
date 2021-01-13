import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                Text('Sign Up'),
              ],
            ),
          ),
      ),
    );
  }

}