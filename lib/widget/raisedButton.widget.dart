import 'package:flutter/material.dart';

class RaisedButtonWidget extends StatelessWidget {
  final EdgeInsets padding;
  final String label;
  final Color background;
  final Color textColor;
  final VoidCallback onPressed;
  final double width;
  final EdgeInsets paddingInternal;
  final TextStyle style;
  final double elevation;

  RaisedButtonWidget({
    this.width,
    @required this.padding,
    this.paddingInternal,
    @required this.label,
    @required this.background,
    @required this.textColor,
    this.style,
    this.elevation,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: this.padding,
        width: this.width,
        child: RaisedButton(
          child: Text(
            this.label,
            style: this.style,
          ),
          elevation: this.elevation,
          onPressed: this.onPressed,
          color: this.background,
          textColor: this.textColor,
          padding: this.paddingInternal,
        ));
  }
}
