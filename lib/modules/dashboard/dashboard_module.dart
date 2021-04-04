import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme_config.dart';
import 'package:parkinson_de_bolso/model/navegation_model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/patient_module.dart';
import 'package:parkinson_de_bolso/modules/dashboard/report/report_module.dart';
import 'package:parkinson_de_bolso/modules/dashboard/setting/setting_module.dart';

class DashboardModule extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  _DashboardModuleState createState() => _DashboardModuleState();
}

class _DashboardModuleState extends State<DashboardModule>
    with TickerProviderStateMixin<DashboardModule> {
  int _currentIndex = 0;
  final _navegation = <NavegationModel>[
    NavegationModel('Pacientes', Icons.people, NavegationType.PATIENT),
    NavegationModel('Relatórios', Icons.analytics, NavegationType.REPORT),
    NavegationModel('Configurações', Icons.settings, NavegationType.SETTING)
  ];

  Widget _getNavegationWidget(NavegationType type) {
    switch (type) {
      case NavegationType.PATIENT:
        return PatientModule();
      case NavegationType.REPORT:
        return ReportModule();
      case NavegationType.SETTING:
        return SettingModule();
      default:
        return Center(child: Text('Page not found!'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: this
              ._navegation
              .map<Widget>((NavegationModel navegation) =>
                  this._getNavegationWidget(navegation.type))
              .toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ThemeConfig.dashboardBarColor,
        unselectedItemColor: ThemeConfig.secondaryColorDashboardBar,
        selectedItemColor: ThemeConfig.primaryColorDashboardBar,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: this._navegation.map((NavegationModel navegation) {
          return BottomNavigationBarItem(
            icon: Icon(navegation.icon),
            label: navegation.title,
          );
        }).toList(),
      ),
    );
  }
}
