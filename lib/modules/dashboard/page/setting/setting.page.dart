import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
// import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/route/dashboard.route.dart';
import 'package:parkinson_de_bolso/service/notify.service.dart';
import 'package:parkinson_de_bolso/service/setting.service.dart';
import 'package:parkinson_de_bolso/util/string.util.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';
import 'package:parkinson_de_bolso/widget/custom_circle_avatar.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';

class SettingPage extends StatefulWidget {
  static final String name = 'Configurações';

  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class SettingPageAction {
  final String label;
  final VoidCallback action;
  SettingPageAction(this.label, this.action);
}

class _SettingPageState extends State<SettingPage> with StringUtil {
  bool _loading, _leaveComment;
  TextEditingController comment;

  @override
  void initState() {
    this.comment = new TextEditingController();
    this._loading = false;
    this._leaveComment = false;
    super.initState();
  }

  Widget _createButton(SettingPageAction action) {
    return CustomRaisedButton(
      padding: EdgeInsets.all(10),
      paddingInternal: EdgeInsets.all(20),
      label: action.label,
      background: ThemeConfig.primaryColor,
      textColor: ThemeConfig.ternaryColor,
      onPressed: action.action,
      width: double.infinity,
      elevation: 0,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }

  Widget _getButtons() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          this._createButton(
            SettingPageAction(
              'Deixar um comentário',
              () {
                this.setState(
                  () => this._leaveComment = true,
                );
              },
            ),
          ),
          this._createButton(
            SettingPageAction(
              'Limpar dados',
              () {
                this.setState(
                  () => this._loading = true,
                );
                SettingService.instance.cleanData().whenComplete(
                      () => this.setState(
                        () => this._loading = false,
                      ),
                    );
              },
            ),
          ),
          this._createButton(
            SettingPageAction(
              'Excluir conta',
              () {
                this.setState(
                  () => this._loading = true,
                );
                SettingService.instance
                    .deleteAccount()
                    .then(
                      (_) => DashboardRoutes.instance.logout(),
                    )
                    .whenComplete(
                      () => this.setState(
                        () => this._loading = false,
                      ),
                    );
              },
            ),
          )
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
            style: TextStyle(
              color: ThemeConfig.primaryColor,
              fontSize: 20,
            ),
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
                  borderSide: BorderSide(
                    color: ThemeConfig.primaryColor,
                  ),
                ),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomRaisedButton(
              background: ThemeConfig.primaryColor,
              label: 'Enviar',
              padding: EdgeInsets.all(10),
              onPressed: () {
                this.setState(() {
                  NotifyService.instance.sendComment(
                    this.comment.text,
                  );
                  this._leaveComment = false;
                });
              },
              textColor: ThemeConfig.ternaryColor,
              elevation: 0,
            ),
            CustomRaisedButton(
              background: ThemeConfig.primaryColor,
              label: 'Voltar',
              padding: EdgeInsets.all(10),
              onPressed: () {
                this.setState(() {
                  this._leaveComment = false;
                });
              },
              textColor: ThemeConfig.ternaryColor,
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
    if (AppConfig.instance.loggedInUser == null)
      return Text('User not logged in');

    return CustomBackground(
      margin: 10.0,
      topColor: ThemeConfig.dashboardBarColor,
      bottomColor: ThemeConfig.ternaryColor,
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
                background: ThemeConfig.ternaryColor,
                foreground: ThemeConfig.primaryColor,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppConfig.instance.loggedInUser.name,
                  style: TextStyle(
                    color: ThemeConfig.ternaryColor,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  AppConfig.instance.loggedInUser.email,
                  style: TextStyle(
                    color: ThemeConfig.ternaryColor,
                    fontSize: 16,
                  ),
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
        duration: Duration(
          milliseconds: 300,
        ),
      ),
      horizontalPadding: 10.0,
    );
  }
}
