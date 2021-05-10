import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/camera.config.dart';
import 'package:parkinson_de_bolso/material/auth.material.dart';
import 'package:parkinson_de_bolso/material/dashboard.material.dart';
import 'package:parkinson_de_bolso/type/module.type.dart';
import 'package:parkinson_de_bolso/util/sharedPreferences.util.dart';

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
  ModuleType _moduleType;

  @override
  void initState() {
    super.initState();
    this._moduleType = ModuleType.AUTH;
    AppConfig.instance.setChangeModuleFunction(changeModule);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    switch (_moduleType) {
      case ModuleType.AUTH:
        return AuthMaterial();
      case ModuleType.CAMERA:
      case ModuleType.DASHBOARD:
      case ModuleType.NOTIFICATION:
        return DashMaterial(
          moduleType: this._moduleType,
        );
      default:
        return AuthMaterial();
    }
  }

  changeModule(ModuleType type) {
    this.setState(() => this._moduleType = type);
  }
}
