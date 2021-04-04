import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parkinson_de_bolso/config/app_config.dart';
import 'package:parkinson_de_bolso/config/camera_config.dart';
import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/config/theme_config.dart';
import 'package:parkinson_de_bolso/modules/auth/onboarding/onboarding.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_in/sign_in.dart';
import 'package:parkinson_de_bolso/util/shared_preferences_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  await AppConfig.instance.initialize();
  await CameraConfig.instance.load();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SharedPreferencesUtil {
  @override
  void initState() {
    super.initState();
    RouteConfig.configureRoutes();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.instance.applicationName,
      theme: ThemeData(fontFamily: ThemeConfig.defaultFont),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteConfig.instance.exchange(),
      home: AppConfig.instance.firstAccess ? Onboarding() : SignIn(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
    );
  }
}
