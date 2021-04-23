import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme_config.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';
import 'package:parkinson_de_bolso/widget/custom_buttom_notification.dart';

class ReportModule extends StatefulWidget {
  ReportModule({Key key}) : super(key: key);

  @override
  _ReportModuleState createState() => _ReportModuleState();
}

class _ReportModuleState extends State<ReportModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: CustomButtomNotification(),
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: ThemeConfig.dashboardBarColor,
          title: Text('Relatórios'),
        ),
        body: CustomBackground(
            margin: 10.0,
            topColor: ThemeConfig.dashboardBarColor,
            bottomColor: ThemeConfig.ternaryColor,
            bottom: Center(
              child: Text('Relatórios'),
            ),
            horizontalPadding: 10.0));
  }
}
