import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/notification.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/appBarButton.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/action/dashboard.actions.dart';
import 'package:parkinson_de_bolso/route/dashboard.route.dart';
import 'package:parkinson_de_bolso/type/module.type.dart';

class DashboardMaterial extends StatefulWidget {
  final Widget appBarTitle;
  final List<AppBarButtonModel> actions;
  final IconButton leading;
  final ModuleType type;

  const DashboardMaterial({
    Key key,
    @required this.appBarTitle,
    @required this.actions,
    @required this.leading,
    @required this.type,
  }) : super(key: key);

  @override
  _DashboardMaterialState createState() => _DashboardMaterialState();
}

class _DashboardMaterialState extends State<DashboardMaterial> {
  int _activeNotifications;

  @override
  void initState() {
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
  void dispose() {
    NotificationConfig.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.instance.applicationName,
      theme: ThemeData(
        fontFamily: ThemeConfig.defaultFont,
        primaryColor: ThemeConfig.primaryColor,
        appBarTheme: AppBarTheme(
          color: ThemeConfig.primaryColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: DashboardRoutes.instance.getRoutes(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      builder: (context, child) {
        return _StandardDashboardPanel(
          child: child,
          appBarTitle: this.widget.appBarTitle,
          actions: this.widget.actions,
          numberActiveNotifications: this._activeNotifications,
          leading: this.widget.leading,
          type: this.widget.type,
        );
      },
    );
  }
}

class _StandardDashboardPanel extends StatelessWidget {
  final Widget child;
  final Widget appBarTitle;
  final List<AppBarButtonModel> actions;
  final int numberActiveNotifications;
  final IconButton leading;
  final ModuleType type;

  const _StandardDashboardPanel({
    Key key,
    @required this.child,
    @required this.appBarTitle,
    @required this.actions,
    @required this.numberActiveNotifications,
    @required this.leading,
    @required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (this.type == ModuleType.DASHBOARD)
          ? AppBar(
              elevation: 0,
              leading: this.leading,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: this.appBarTitle,
              actions: this._buildActions(context),
            )
          : null,
      body: child,
    );
  }

  List<Object> _buildActions(context) {
    List<Object> actions = this
        .actions
        .map(
          (e) => IconButton(
            icon: e.icon,
            onPressed: e.action,
          ),
        )
        .toList();
    actions.add(_buildButtonNotification(context));
    return actions;
  }

  IconButton _buildButtonNotification(context) {
    return IconButton(
      icon: Container(
        child: Stack(
          children: [
            Icon(
              Icons.notifications,
              color: ThemeConfig.ternaryColor,
              size: 30,
            ),
            if (this.numberActiveNotifications > 0)
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: ThemeConfig.secondaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      border: Border.all(
                        color: ThemeConfig.secondaryColor,
                        width: 1,
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(
                      0.0,
                    ),
                    child: Center(
                      child: Text(
                        this.numberActiveNotifications.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: ThemeConfig.ternaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      onPressed: DashboardActions.instance.callOpenNavegationPageFunction,
    );
  }
}
