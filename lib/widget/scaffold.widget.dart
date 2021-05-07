import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScaffoldWidget extends StatelessWidget {
  final Widget child;
  final FloatingActionButton floatingActionButton;

  ScaffoldWidget({
    @required this.child,
    this.floatingActionButton,
  });

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
