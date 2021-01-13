import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomRaisedButton extends StatefulWidget {
  EdgeInsets padding;
  String label;
  Color background;
  Color textColor;
  @required VoidCallback onPressed;

  CustomRaisedButton({this.padding, this.label, this.background, this.textColor, this.onPressed}) : 
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
        child: RaisedButton(
          child: Text(widget.label),
          onPressed: widget.onPressed,
          color: widget.background,
          textColor: widget.textColor,
        ));
  }
}