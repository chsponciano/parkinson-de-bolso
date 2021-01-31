import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/route.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/service/setting_service.dart';
import 'package:parkinson_de_bolso/util/string_util.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';
import 'package:parkinson_de_bolso/widget/custom_circle_avatar.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';

class SettingModule extends StatefulWidget {
  const SettingModule({ Key key }) : super(key: key);

  @override
  _SettingModuleState createState() => _SettingModuleState();  
}

class SettingModuleAction {
  final String label;
  final VoidCallback action;
  SettingModuleAction(this.label, this.action);
}

class _SettingModuleState extends State<SettingModule> {
  bool _loading;

  @override
  void initState() {
    this._loading = false;
    super.initState();
  }

  Widget _createButton(SettingModuleAction action) {
    return CustomRaisedButton(
      padding: EdgeInsets.all(10),
      paddingInternal: EdgeInsets.all(20),
      label: action.label, 
      background: primaryColor,
      textColor: ternaryColor, 
      onPressed: action.action,
      width: double.infinity,
      elevation: 0,
      style: TextStyle(
        fontSize: 16
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (RouteHandler.loggedInUser == null)
      return Text('User not logged in');
      
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: dashboardBarColor,
        title: Text('Configurações'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: Icon(
              Icons.logout,
              color: ternaryColor,
            ),
            onPressed: () => RouteHandler.instance.exit(context),
          )
        ],
      ),
      body: CustomBackground(
        margin: 10.0,
        topColor: dashboardBarColor, 
        bottomColor: ternaryColor, 
        loading: this._loading,
        top: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: CustomCircleAvatar(
                  radius: 20, 
                  background: ternaryColor, 
                  foreground: primaryColor,
                  initials: StringUtil.getInitials(RouteHandler.loggedInUser.name),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    RouteHandler.loggedInUser.name,
                    style: TextStyle(
                      color: ternaryColor,
                      fontSize: 18
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    RouteHandler.loggedInUser.email,
                    style: TextStyle(
                      color: ternaryColor,
                      fontSize: 16
                    ),
                  )
                ],
              ),
              
            ],
          ),
        ),
        bottom: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              this._createButton(SettingModuleAction('Limpar dados', () {
                this.setState(() => this._loading = true);
                SettingService.instance.clearData()
                .whenComplete(() => this._loading = false);
              })),
              this._createButton(SettingModuleAction('Excluir conta', () async {
                this.setState(() => this._loading = true);
                SettingService.instance.deleteAccount()
                .then((_) => RouteHandler.instance.exit(context))
                .whenComplete(() => this._loading = false);
              }))
            ],
          ),
        ),
        horizontalPadding: 10.0
      )
    );
  }
}