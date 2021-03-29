import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/service/setting_service.dart';
import 'package:parkinson_de_bolso/util/string_util.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';
import 'package:parkinson_de_bolso/widget/custom_circle_avatar.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';

class SettingModule extends StatefulWidget {
  const SettingModule({Key key}) : super(key: key);

  @override
  _SettingModuleState createState() => _SettingModuleState();
}

class SettingModuleAction {
  final String label;
  final VoidCallback action;
  SettingModuleAction(this.label, this.action);
}

class _SettingModuleState extends State<SettingModule> with StringUtil {
  bool _loading, _leaveComment;
  TextEditingController comment;

  @override
  void initState() {
    this.comment = new TextEditingController();
    this._loading = false;
    this._leaveComment = false;
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
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _getButtons() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          this._createButton(SettingModuleAction('Deixar um comentário', () {
            this.setState(() => this._leaveComment = true);
          })),
          this._createButton(SettingModuleAction('Limpar dados', () {
            this.setState(() => this._loading = true);
            SettingService.instance
                .cleanData()
                .whenComplete(() => this.setState(() => this._loading = false));
          })),
          this._createButton(SettingModuleAction('Excluir conta', () {
            this.setState(() => this._loading = true);
            SettingService.instance
                .deleteAccount()
                .then((_) => RouteHandler.instance.exit(context))
                .whenComplete(() => this.setState(() => this._loading = false));
          }))
        ],
      ),
    );
  }

  Widget _getCommentForm() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(30),
          child: Text(
            'Deixar um comentário',
            style: TextStyle(color: primaryColor, fontSize: 20),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: this.comment,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor))),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomRaisedButton(
              background: primaryColor,
              label: 'Enviar',
              padding: EdgeInsets.all(10),
              onPressed: () {
                this.setState(() {
                  this._leaveComment = false;
                });
              },
              textColor: ternaryColor,
              elevation: 0,
            ),
            CustomRaisedButton(
              background: primaryColor,
              label: 'Voltar',
              padding: EdgeInsets.all(10),
              onPressed: () {
                this.setState(() {
                  this._leaveComment = false;
                });
              },
              textColor: ternaryColor,
              elevation: 0,
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    this.comment.clear();
    if (RouteHandler.loggedInUser == null) return Text('User not logged in');

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
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        RouteHandler.loggedInUser.name,
                        style: TextStyle(color: ternaryColor, fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(
                        RouteHandler.loggedInUser.email,
                        style: TextStyle(color: ternaryColor, fontSize: 16),
                      )
                    ],
                  ),
                ],
              ),
            ),
            bottom: AnimatedCrossFade(
                firstChild: this._getButtons(),
                secondChild: this._getCommentForm(),
                crossFadeState: !this._leaveComment
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 300)),
            horizontalPadding: 10.0));
  }
}
