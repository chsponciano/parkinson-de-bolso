import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/camera.config.dart';
import 'package:parkinson_de_bolso/material/auth.material.dart';
import 'package:parkinson_de_bolso/material/dashboard.material.dart';
import 'package:parkinson_de_bolso/model/appBarButton.model.dart';
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
  Widget _appBarTitle;
  List<AppBarButtonModel> _actions;
  IconButton _leading;

  @override
  void initState() {
    super.initState();
    this._moduleType = ModuleType.AUTH;
    AppConfig.instance.setChangeModuleFunction(
      (
        ModuleType type,
        Widget appBarTitle,
        List<AppBarButtonModel> actions,
        IconButton leading,
      ) =>
          this.setState(
        () {
          this._moduleType = type;
          this._appBarTitle = appBarTitle;
          this._actions = actions;
          this._leading = leading;
        },
      ),
    );
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
        return DashboardMaterial(
          appBarTitle: this._appBarTitle,
          actions: this._actions,
          leading: this._leading,
          type: this._moduleType,
        );
      default:
        return AuthMaterial();
    }
  }
}
