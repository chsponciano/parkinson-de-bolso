import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parkinson_de_bolso/config/camera_config.dart';
import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/modules/auth/onboarding/onboarding.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_in/sign_in.dart';
import 'package:parkinson_de_bolso/util/shared_preferences_util.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  await DotEnv.load(fileName: '.env');
  await CameraHandler.instance.load();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SharedPreferencesUtil {
  bool _firstAccess = false;

  _AppState() {
    Future<dynamic> user = this.getPrefs('user_email');
    user.then((value) => this.setState(() {
          this._firstAccess = value == null;
        }));
  }

  @override
  void initState() {
    super.initState();
    RouteHandler.loggedInUser = null;
    RouteHandler.session = null;
    RouteHandler.configureRoutes();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: applicationName,
      theme: ThemeData(fontFamily: defaultFont),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteHandler.instance.exchange(),
      home: this._firstAccess ? Onboarding() : SignIn(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
    );
  }
}
