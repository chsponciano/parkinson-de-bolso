import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';

class CustomTextField extends StatelessWidget {
  final double height;
  final Color color;
  final String hint;
  final IconData icon;
  final EdgeInsets padding;
  final double borderRadius;
  final String title;
  final TextInputType type;
  final double distanceNextLine;
  final Object inputDecoration;
  final bool isShadow;

  CustomTextField({this.title, @required this.height, @required this.color, @required this.hint, @required this.icon, this.type, @required this.padding, @required this.borderRadius, this.distanceNextLine, this.inputDecoration, this.isShadow = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (this.title != null)
          Text(
            this.title,
            style: TextStyle(
              color: this.color,
              fontWeight: FontWeight.bold,
              fontFamily: defaultFont,
            ),
          ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(this.borderRadius),
            boxShadow: (this.isShadow) ? [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ] : null,
          ),
          height: this.height,
          child: TextField(
            obscureText: (this.type == null),
            keyboardType: this.type,
            style: TextStyle(
              color: this.color,
              fontFamily: defaultFont,
            ),
            decoration: (this.inputDecoration != null) ? this.inputDecoration : InputDecoration(
              border: InputBorder.none,
              contentPadding: this.padding,
              prefixIcon: Icon(
                this.icon,
                color: this.color,
              ),
              hintText: this.hint,
              hintStyle: TextStyle(
                color: this.color,
                fontFamily: defaultFont,
              ),
            ),
          ),
        ),
        SizedBox(height: (this.distanceNextLine == null) ? 0.0 : this.distanceNextLine)
      ],
    );
  }
}