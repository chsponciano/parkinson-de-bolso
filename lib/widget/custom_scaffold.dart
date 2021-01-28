import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;
  final FloatingActionButton floatingActionButton;

  CustomScaffold({@required this.child, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: this.child,
      ),
      floatingActionButton: this.floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}