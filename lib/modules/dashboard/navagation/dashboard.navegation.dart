import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/navegation.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/action/dashboard.actions.dart';
import 'package:parkinson_de_bolso/modules/dashboard/page/patient/patient.main.page.dart';
import 'package:parkinson_de_bolso/modules/dashboard/page/report/report.page.dart';
import 'package:parkinson_de_bolso/modules/dashboard/page/setting/setting.page.dart';
import 'package:parkinson_de_bolso/route/dashboard.route.dart';
import 'package:parkinson_de_bolso/type/navegation.type.dart';

class DashboardNavegation extends StatefulWidget {
  static const String routeName = '/';

  @override
  _DashboardNavegationState createState() => _DashboardNavegationState();
}

class _DashboardNavegationState extends State<DashboardNavegation> {
  final _navegation = <NavegationModel>[
    NavegationModel(PatientMainPage.name, Icons.people, NavegationType.PATIENT),
    NavegationModel(ReportPage.name, Icons.analytics, NavegationType.REPORT),
    NavegationModel(SettingPage.name, Icons.settings, NavegationType.SETTING)
  ];
  int _currentIndex;
  bool _activeNavigation;

  @override
  void initState() {
    this._currentIndex = 0;
    this._activeNavigation = true;
    DashboardActions.instance.setOnActiveNavegationFunction(
      (bool active) => this.setState(
        () => this._activeNavigation = active,
      ),
    );
    DashboardRoutes.instance.setChangeNavegationIndexFunction(
      (int index) => this.setState(
        () => this._currentIndex = index,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: this._currentIndex,
          children: this
              ._navegation
              .map<Widget>(
                (NavegationModel navegation) => this._getNavegationWidget(
                  navegation.type,
                ),
              )
              .toList(),
        ),
      ),
      bottomNavigationBar: (this._activeNavigation)
          ? BottomNavigationBar(
              backgroundColor: ThemeConfig.dashboardBarColor,
              unselectedItemColor: ThemeConfig.secondaryColorDashboardBar,
              selectedItemColor: ThemeConfig.primaryColorDashboardBar,
              currentIndex: this._currentIndex,
              onTap: (int index) =>
                  DashboardRoutes.instance.setRouteNavagtion(index),
              items: this._navegation.map((NavegationModel navegation) {
                return BottomNavigationBarItem(
                  icon: Icon(
                    navegation.icon,
                  ),
                  label: navegation.title,
                );
              }).toList(),
            )
          : null,
    );
  }

  Widget _getNavegationWidget(NavegationType type) {
    switch (type) {
      case NavegationType.PATIENT:
        return PatientMainPage();
      case NavegationType.REPORT:
        return ReportPage();
      case NavegationType.SETTING:
        return SettingPage();
      default:
        return Center(child: Text('Page not found!'));
    }
  }
}
