import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomOutlineButton extends StatelessWidget {
  @required EdgeInsets padding;
  @required String label;
  @required Color background;
  @required Color textColor;
  @required VoidCallback onPressed;

  CustomOutlineButton({this.padding, this.label, this.background, this.textColor, this.onPressed}) : 
        assert(padding != null),
        assert(label != null),
        assert(background != null),
        assert(textColor != null),
        assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding,
      child: OutlineButton(
        child: Text(this.label),
        onPressed: this.onPressed,
        textColor: this.textColor,
        borderSide: BorderSide(color: this.background),
      )
    );
  }
}