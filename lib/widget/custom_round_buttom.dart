import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {
  final double width;
  final Color color;
  final Color highlightColor;
  final double opacity;
  final VoidCallback onPressed;

  CustomRoundButton({@required this.width, @required this.color, @required this.highlightColor, this.opacity = 0.5, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: this.width,
          decoration: BoxDecoration(
            color: this.color,
            shape: BoxShape.circle
          ),
        ),
        Container(
          width: this.width - 10,
          height: this.width - 10,
          child: RaisedButton(
            highlightColor: this.highlightColor,
            color: this.color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(
                  color: Colors.black.withOpacity(this.opacity),
                  width: 4
                )
            ),
            onPressed: this.onPressed,
          )
        ),
      ],
    );
  }

}