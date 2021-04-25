import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';

class ReportPage extends StatefulWidget {
  static final String name = 'Relatórios';

  ReportPage({Key key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      margin: 10.0,
      topColor: ThemeConfig.dashboardBarColor,
      bottomColor: ThemeConfig.ternaryColor,
      bottom: Center(
        child: Text(
          'Relatórios',
        ),
      ),
      horizontalPadding: 10.0,
    );
  }
}
