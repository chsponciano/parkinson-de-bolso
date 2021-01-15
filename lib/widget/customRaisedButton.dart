import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomRaisedButton extends StatefulWidget {
  double width;
  EdgeInsets padding;
  EdgeInsets paddingInternal;
  String label;
  Color background;
  Color textColor;
  TextStyle style;
  double elevation;
  @required VoidCallback onPressed;

  CustomRaisedButton({this.width, this.padding, this.paddingInternal, this.label, this.background, this.textColor, this.style, this.elevation, this.onPressed}) : 
        assert(padding != null),
        assert(label != null),
        assert(background != null),
        assert(textColor != null),
        assert(onPressed != null);

  @override
  _CustomRaisedButtonState createState() => _CustomRaisedButtonState();
}

class _CustomRaisedButtonState extends State<CustomRaisedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: widget.padding,
        width: widget.width,
        child: RaisedButton(
          child: Text(
            widget.label, 
            style: widget.style
          ),
          elevation: widget.elevation,
          onPressed: widget.onPressed,
          color: widget.background,
          textColor: widget.textColor,
          padding: widget.paddingInternal,
        ));
  }
}