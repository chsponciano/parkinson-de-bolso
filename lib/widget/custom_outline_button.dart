import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final EdgeInsets padding;
  final String label;
  final Color background;
  final Color textColor;
  final VoidCallback onPressed;

  CustomOutlineButton({@required this.padding, @required this.label, @required this.background, @required this.textColor, @required this.onPressed}) : 
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