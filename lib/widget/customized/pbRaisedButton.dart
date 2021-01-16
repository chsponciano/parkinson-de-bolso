import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PbRaisedButton extends StatelessWidget {
  double width;
  EdgeInsets padding;
  EdgeInsets paddingInternal;
  String label;
  Color background;
  Color textColor;
  TextStyle style;
  double elevation;
  @required VoidCallback onPressed;

  PbRaisedButton({this.width, this.padding, this.paddingInternal, this.label, this.background, this.textColor, this.style, this.elevation, this.onPressed}) : 
        assert(padding != null),
        assert(label != null),
        assert(background != null),
        assert(textColor != null),
        assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding,
      width: this.width,
      child: RaisedButton(
        child: Text(
          this.label, 
          style: this.style
        ),
        elevation: this.elevation,
        onPressed: this.onPressed,
        color: this.background,
        textColor: this.textColor,
        padding: this.paddingInternal,
      )
    );
  }
}