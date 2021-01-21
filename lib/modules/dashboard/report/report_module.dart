import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';

class ReportModule extends StatefulWidget {
  const ReportModule({ Key key }) : super(key: key);

  @override
  _ReportModuleState createState() => _ReportModuleState();  
}

class _ReportModuleState extends State<ReportModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dashboardBarColor,
        title: Text('Relatórios'),
      ),
      body: Center(
        child: Text('Relatórios'),
      )
    );
  }
}