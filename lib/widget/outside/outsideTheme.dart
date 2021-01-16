import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/widget/customized/customized.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';

// ignore: must_be_immutable
class OutsideTheme extends StatelessWidget {
  List<Widget> children = const <Widget>[];

  OutsideTheme({this.children}) : assert(children != null);

  @override
  Widget build(BuildContext context) {
    return PbScaffold(
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
                  children: this.children
                )
              )
            )
          ]
        )
      )
    );
  }

}