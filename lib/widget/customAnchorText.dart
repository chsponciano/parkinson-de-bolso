import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAnchorText extends StatefulWidget {
  Alignment alignment;
  String caption;
  Color color;
  @required VoidCallback onPressed;

  CustomAnchorText({this.alignment, this.caption, this.color, this.onPressed}) :
    assert(alignment != null),
    assert(caption != null),
    assert(color != null),
    assert(onPressed != null);

  @override
  CustomAnchorTextState createState() => CustomAnchorTextState();
}

class CustomAnchorTextState extends State<CustomAnchorText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.alignment,
      child: FlatButton(
        onPressed: widget.onPressed,
        child: Text(
          widget.caption,
          style: TextStyle(
            color: widget.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}