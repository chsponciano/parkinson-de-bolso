import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/dash.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/search.patient.dash.dart';
import 'package:parkinson_de_bolso/modules/dashboard/report/report.dash.dart';
import 'package:parkinson_de_bolso/service/setting.service.dart';

class MenuDash extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  const MenuDash({Key key, this.scaffoldState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(AppConfig.instance.loggedInUser.name),
            accountEmail: Text(AppConfig.instance.loggedInUser.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: ThemeConfig.ternaryColor,
              child: Text(
                AppConfig.instance.loggedInUser.name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 40.0,
                  color: ThemeConfig.primaryColor,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Pacientes'),
            trailing: Icon(Icons.people),
            onTap: () {
              this.scaffoldState.currentState.openDrawer();
              Navigator.pushNamed(
                DashConfig.instance.getContext(),
                SearchPatientDash.routeName,
              );
            },
          ),
          ListTile(
            title: Text('Relatórios'),
            trailing: Icon(Icons.analytics),
            onTap: () {
              this.scaffoldState.currentState.openDrawer();
              Navigator.pushNamed(
                DashConfig.instance.getContext(),
                ReportDash.routeName,
              );
            },
          ),
          ListTile(
            title: Text('Limpar dados'),
            trailing: Icon(Icons.clear_all),
            onTap: () {
              SettingService.instance.cleanData().whenComplete(
                () {
                  this.scaffoldState.currentState.openDrawer();
                  Navigator.pushNamed(
                    DashConfig.instance.getContext(),
                    SearchPatientDash.routeName,
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text('Excluir conta'),
            trailing: Icon(Icons.delete_forever),
            onTap: () {
              SettingService.instance.deleteUser().whenComplete(
                    DashConfig.instance.logout,
                  );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Desconectar'),
            trailing: Icon(Icons.logout),
            onTap: DashConfig.instance.logout,
          ),
        ],
      ),
    );
  }
}
