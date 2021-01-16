import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class PbScaffold extends StatelessWidget {
  Widget child;

  PbScaffold({this.child}) : 
    assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: this.child,
      )
    );
  }
}