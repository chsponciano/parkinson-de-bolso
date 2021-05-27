import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/adapter/dialog.adapter.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/dash.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/search.patient.dash.dart';
import 'package:parkinson_de_bolso/modules/dashboard/report/report.dash.dart';
import 'package:parkinson_de_bolso/service/notify.service.dart';
import 'package:parkinson_de_bolso/service/setting.service.dart';
import 'package:parkinson_de_bolso/widget/toggle.widget.dart';

class MenuDash extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldState;
  final DialogAdapter _dialogAdapter = DialogAdapter.instance;
  final TextEditingController _textEditingController =
      new TextEditingController();

  MenuDash({Key key, this.scaffoldState}) : super(key: key);

  confirmActions(String title, String message, Function action) {
    this.scaffoldState.currentState.openDrawer();
    this._dialogAdapter.show(
          DashConfig.instance.getContext(),
          DialogType.INFO,
          title,
          message,
          btnOkLabel: 'Sim',
          onOk: action,
        );
  }

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
            onTap: () => this.confirmActions(
              'Limpeza de dados da conta',
              'Deseja realmente limpar todos os dados da sua conta?',
              () {
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
          ),
          ListTile(
            title: Text('Excluir conta'),
            trailing: Icon(Icons.delete_forever),
            onTap: () => this.confirmActions(
              'Exclusão de conta',
              'Deseja realmente excluir sua conta?',
              () {
                SettingService.instance.deleteUser().whenComplete(
                      DashConfig.instance.logout,
                    );
              },
            ),
          ),
          ListTile(
            title: Text('Deixar um comentário'),
            trailing: Icon(Icons.email),
            onTap: () {
              this.scaffoldState.currentState.openDrawer();
              this._dialogAdapter.show(
                DashConfig.instance.getContext(),
                DialogType.NO_HEADER,
                '',
                '',
                btnOkLabel: 'Enviar',
                onOk: () {
                  if (this._textEditingController.text.trim().length > 0) {
                    NotifyService.instance.sendComment(
                      this._textEditingController.text,
                    );
                  }
                  this._dialogAdapter.show(
                        DashConfig.instance.getContext(),
                        DialogType.SUCCES,
                        'Deixar um comentário',
                        'Obrigado pelo seu comentário, estaremos análisando',
                      );
                },
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Deixar um comentário',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Envie sua sugestão ou queixa para auxiliar na melhoria continua do aplicativo',
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        controller: this._textEditingController,
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        maxLengthEnforced: true,
                        minLines: 1,
                        maxLines: null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Desconectar'),
            trailing: Icon(Icons.logout),
            onTap: () => this.confirmActions(
              'Desconectar',
              'Deseja realmente desconectar?',
              DashConfig.instance.logout,
            ),
          ),
          Visibility(
            child: ListTile(
              title: ToggleWidget(
                background: ThemeConfig.primaryColor,
                action: (state) {
                  AppConfig.instance.isAnEmulator = state;
                },
                initial: AppConfig.instance.isAnEmulator,
                label: 'Modo Teste',
              ),
            ),
            visible: AppConfig.instance.loggedInUser.id ==
                '0bf780f1-a77a-47ff-beef-6c37661a0781',
          ),
        ],
      ),
    );
  }
}
