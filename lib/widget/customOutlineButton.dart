import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomOutlineButton extends StatefulWidget {
  EdgeInsets padding;
  String label;
  Color background;
  Color textColor;
  @required VoidCallback onPressed;

  CustomOutlineButton({this.padding, this.label, this.background, this.textColor, this.onPressed}) : 
        assert(padding != null),
        assert(label != null),
        assert(background != null),
        assert(textColor != null),
        assert(onPressed != null);

  @override
  _CustomOutlineButtonState createState() => _CustomOutlineButtonState();
}

class _CustomOutlineButtonState extends State<CustomOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: widget.padding,
        child: OutlineButton(
          child: Text(widget.label),
          onPressed: widget.onPressed,
          textColor: widget.textColor,
          borderSide: BorderSide(color: widget.background),
        ));
  }
}