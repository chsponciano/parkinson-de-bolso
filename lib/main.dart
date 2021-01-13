import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/widget/signIn.dart';
import 'package:parkinson_de_bolso/utilities/route.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: applicationName,
      theme: ThemeData(
        fontFamily: defaultFont
      ),
      debugShowCheckedModeBanner: false,
      home: SignIn(),
      onGenerateRoute: loggedOutRoutes(),
    );
  }
}