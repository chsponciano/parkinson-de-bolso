import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnchorText extends StatelessWidget {
  Alignment alignment;
  String caption;
  Color color;
  @required VoidCallback onPressed;

  AnchorText({this.alignment, this.caption, this.color, this.onPressed}) :
    assert(alignment != null),
    assert(caption != null),
    assert(color != null),
    assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: this.alignment,
      child: FlatButton(
        onPressed: this.onPressed,
        child: Text(
          this.caption,
          style: TextStyle(
            color: this.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}