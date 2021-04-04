import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme_config.dart';
import 'package:parkinson_de_bolso/widget/custom_scaffold.dart';
import 'package:parkinson_de_bolso/widget/custom_title_page.dart';

class AuthModule extends StatefulWidget {
  final String widgetTitle;
  final List<Widget> children;
  final bool activateBackButton;
  final bool loading;

  AuthModule(
      {@required this.widgetTitle,
      @required this.children,
      this.activateBackButton = false,
      this.loading = false});

  @override
  _AuthModuleState createState() => _AuthModuleState();
}

class _AuthModuleState extends State<AuthModule> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration:
                    BoxDecoration(gradient: ThemeConfig.defaultGradient),
              ),
              Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            this._buildTitle(),
                          ]..addAll(this.widget.children)))),
              Visibility(
                visible: this.widget.loading,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.19),
                      ),
                    ),
                    CircularProgressIndicator(
                      backgroundColor: ThemeConfig.ternaryColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          ThemeConfig.primaryColor),
                    )
                  ],
                ),
              )
            ])),
        floatingActionButton: (this.widget.activateBackButton)
            ? this._buildBackButton(context)
            : null);
  }

  Widget _buildTitle() {
    return CustomTitlePage(
      title: this.widget.widgetTitle,
      color: ThemeConfig.ternaryColor,
      distanceNextLine: 30.0,
      addIcon: true,
    );
  }

  FloatingActionButton _buildBackButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pop(context),
      child: Icon(Icons.arrow_back, color: ThemeConfig.ternaryColor),
      backgroundColor: Colors.transparent,
      mini: true,
      elevation: 0,
      tooltip: 'Voltar',
    );
  }
}
