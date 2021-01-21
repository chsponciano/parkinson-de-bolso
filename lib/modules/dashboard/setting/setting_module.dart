import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';

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
        backgroundColor: dashboardBarColor,
        title: Text('Configurações'),
      ),
      body: Center(
        child: Text('Configurações'),
      )
    );
  }
}