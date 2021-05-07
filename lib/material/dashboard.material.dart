import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/dash.config.dart';
import 'package:parkinson_de_bolso/config/notification.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/modules/dashboard/menu/menu.dash.dart';
import 'package:parkinson_de_bolso/route/dash.route.dart';
import 'package:parkinson_de_bolso/type/module.type.dart';
import 'package:parkinson_de_bolso/widget/notificationButton.widget.dart';

class DashMaterial extends StatefulWidget {
  final ModuleType moduleType;

  const DashMaterial({
    Key key,
    this.moduleType,
  }) : super(key: key);

  @override
  _DashMaterialState createState() => _DashMaterialState();
}

class _DashMaterialState extends State<DashMaterial> {
  GlobalKey<ScaffoldState> _scaffoldState;
  Widget _leading;
  Widget _title;
  List<Widget> _actions;
  int _activeNotifications;

  @override
  void initState() {
    this._scaffoldState = new GlobalKey<ScaffoldState>();
    DashConfig.instance.setFunctionToAssignBarAttributes(this.setBarAttributes);
    this._activeNotifications = 0;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => NotificationConfig.instance.initialize(
        context,
        (int value) {
          this.setState(() => this._activeNotifications = value);
        },
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.instance.applicationName,
      theme: ThemeData(
        accentColor: ThemeConfig.ternaryColor,
        fontFamily: ThemeConfig.defaultFont,
        primaryColor: ThemeConfig.primaryColor,
        appBarTheme: AppBarTheme(
          color: ThemeConfig.primaryColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: dashRoutes(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      builder: (context, child) {
        return Scaffold(
          key: this._scaffoldState,
          appBar: (this.widget.moduleType == ModuleType.DASHBOARD)
              ? AppBar(
                  elevation: 0,
                  leading: this._leading,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: this._title,
                  actions: this._buildActions(),
                )
              : null,
          body: child,
          endDrawer: MenuDash(
            scaffoldState: this._scaffoldState,
          ),
        );
      },
    );
  }

  setBarAttributes(Widget leading, Widget title, List<Widget> actions) {
    this.setState(() {
      this._leading = leading;
      this._title = title;
      this._actions = actions;
    });
  }

  List<Widget> _buildActions() {
    List<Widget> actions = [];
    this._actions?.forEach((w) => actions.add(w));

    actions.add(
      NotificationButtonWidget(
        numberActiveNotifications: this._activeNotifications,
      ),
    );

    actions.add(
      IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => this._scaffoldState.currentState.openEndDrawer(),
      ),
    );

    return actions;
  }
}
