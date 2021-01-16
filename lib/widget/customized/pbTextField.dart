import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';

// ignore: must_be_immutable
class PbTextField extends StatelessWidget {
  String title;
  double height;
  Color color;
  String hint;
  IconData icon;
  TextInputType type;
  EdgeInsets padding;
  double borderRadius;
  double distanceNextLine;

  PbTextField({this.title, this.height, this.color, this.hint, this.icon, this.type, this.padding, this.borderRadius, this.distanceNextLine}) : 
        assert(height != null),
        assert(color != null),
        assert(hint != null),
        assert(icon != null),
        assert(padding != null),
        assert(borderRadius != null);

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
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: this.height,
          child: TextField(
            obscureText: (this.type == null),
            keyboardType: this.type,
            style: TextStyle(
              color: this.color,
              fontFamily: defaultFont,
            ),
            decoration: InputDecoration(
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