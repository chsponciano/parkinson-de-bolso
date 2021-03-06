import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/widget/scaffold.widget.dart';
import 'package:parkinson_de_bolso/widget/titlePage.widget.dart';

class AuthBase extends StatefulWidget {
  final String widgetTitle;
  final List<Widget> children;
  final bool activateBackButton;
  final bool loading;

  AuthBase(
      {@required this.widgetTitle,
      @required this.children,
      this.activateBackButton = false,
      this.loading = false});

  @override
  _AuthBaseState createState() => _AuthBaseState();
}

class _AuthBaseState extends State<AuthBase> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: ThemeConfig.defaultGradient,
                ),
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
                    ]..addAll(this.widget.children),
                  ),
                ),
              ),
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
                        ThemeConfig.primaryColor,
                      ),
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
    return TitlePageWidget(
      title: this.widget.widgetTitle,
      color: ThemeConfig.ternaryColor,
      distanceNextLine: 30.0,
      addIcon: true,
    );
  }

  FloatingActionButton _buildBackButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pop(context),
      child: Icon(
        Icons.arrow_back,
        color: ThemeConfig.ternaryColor,
      ),
      backgroundColor: Colors.transparent,
      mini: true,
      elevation: 0,
      tooltip: 'Voltar',
    );
  }
}
