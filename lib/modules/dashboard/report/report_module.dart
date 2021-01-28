import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';

class ReportModule extends StatefulWidget {
  ReportModule({ Key key }) : super(key: key);

  @override
  _ReportModuleState createState() => _ReportModuleState();  
}

class _ReportModuleState extends State<ReportModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: dashboardBarColor,
        title: Text('Relatórios'),
      ),
      body: CustomBackground(
        margin: 10.0,
        topColor: dashboardBarColor, 
        bottomColor: ternaryColor, 
        bottom: Center(
          child: Text('Relatórios'),
        ), 
        horizontalPadding: 10.0
      )
    );
  }
}