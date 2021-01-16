import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/widget/custom_scaffold.dart';
import 'package:parkinson_de_bolso/widget/custom_title_page.dart';

// ignore: must_be_immutable
class AuthModule extends StatefulWidget {
  @required String widgetTitle;
  @required List<Widget> children = const <Widget>[];

  AuthModule({this.widgetTitle, this.children}) : 
    assert(widgetTitle != null),
    assert(children != null);

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
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 120.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: this.widget.children
                )
              )
            )
          ]
        )
      )
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
}