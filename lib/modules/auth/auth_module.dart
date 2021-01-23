import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/widget/custom_scaffold.dart';
import 'package:parkinson_de_bolso/widget/custom_title_page.dart';

class AuthModule extends StatefulWidget {
  final String widgetTitle;
  final List<Widget> children;
  final bool activateBackButton;

  AuthModule({@required this.widgetTitle, @required this.children, this.activateBackButton = false});

  @override
  _AuthModuleState createState() => _AuthModuleState();
}

class _AuthModuleState extends State<AuthModule> {
  @override
  void initState() {
    super.initState();
    this.widget.children.insert(0, this._buildTitle());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: defaultGradient
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
                  children: this.widget.children
                )
              )
            )
          ]
        )
      ),
      floatingActionButton: (this.widget.activateBackButton) ? this._buildBackButton(context) : null
    );
  }

  Widget _buildTitle() {
    return CustomTitlePage(
      title: this.widget.widgetTitle,
      color: ternaryColor,
      distanceNextLine: 30.0,
      addIcon: true,
    );
  }

  FloatingActionButton _buildBackButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pop(context),
      child: Icon(Icons.arrow_back, color: primaryColor),
      backgroundColor: ternaryColor,
      mini: true
    );
  }
}