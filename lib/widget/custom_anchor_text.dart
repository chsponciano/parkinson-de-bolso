import 'package:flutter/material.dart';

class CustomAnchorText extends StatelessWidget {
  final Alignment alignment;
  final String caption;
  final Color color;
  final VoidCallback onPressed;

  CustomAnchorText({@required this.alignment, @required this.caption, @required this.color, @required this.onPressed});

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