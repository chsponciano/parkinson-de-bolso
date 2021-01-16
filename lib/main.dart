import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/widget/inside/insideApp.dart';
import 'package:parkinson_de_bolso/widget/outside/outsideApp.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();  
}

class _AppState extends State<App> {
  bool loggedIn;
  String token;

  @override
  void initState() {
    super.initState();
    this.loggedIn = false;
    this.token = null;
  }

  @override
  Widget build(BuildContext context) {
    return (this.loggedIn) ? InsideApp() : OutsideApp(loginAction: (token) {
      setState(() {
        this.token = token;
        this.loggedIn = true;
      });
    });
  }

}