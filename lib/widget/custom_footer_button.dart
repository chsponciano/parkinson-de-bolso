import 'package:flutter/material.dart';
import 'custom_outline_button.dart';

// ignore: must_be_immutable
class CustomFooterButton extends StatelessWidget {
  @required String label;
  @required Color background;
  @required VoidCallback onPressed;

  CustomFooterButton({this.label, this.background, this.onPressed}) :
    assert(label != null),
    assert(background != null),
    assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomOutlineButton(
        background: this.background,
        textColor: this.background,
        label: this.label,
        onPressed: this.onPressed,
        padding: EdgeInsets.all(10)
      ),
    );
  }
}

