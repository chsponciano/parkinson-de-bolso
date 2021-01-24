import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';

class SettingModule extends StatefulWidget {
  const SettingModule({ Key key }) : super(key: key);

  @override
  _SettingModuleState createState() => _SettingModuleState();  
}

class _SettingModuleState extends State<SettingModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: dashboardBarColor,
        title: Text('Configurações'),
      ),
      body: CustomBackground(
        margin: 10.0,
        topColor: dashboardBarColor, 
        bottomColor: ternaryColor, 
        top: null, 
        bottom: Center(
          child: Text('Configurações'),
        ), 
        horizontalPadding: 10.0
      )
    );
  }
}