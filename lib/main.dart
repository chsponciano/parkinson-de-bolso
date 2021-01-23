import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parkinson_de_bolso/config/route.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/modules/dashboard/dashboard_module.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();  
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
    RouteHandler.loggedIn = false;
    RouteHandler.token = null;
    RouteHandler.configureRoutes();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: applicationName,
      theme: ThemeData(
        fontFamily: defaultFont
      ),
      debugShowCheckedModeBanner: false,
      // onGenerateRoute: RouteHandler.instance.exchange(),
      home: DashboardModule(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
    );
  }
}