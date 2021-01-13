import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  String title;
  double height;
  Color color;
  String hint;
  IconData icon;
  TextInputType type;
  EdgeInsets padding;
  double borderRadius;
  double distanceNextLine;

  CustomTextField({this.title, this.height, this.color, this.hint, this.icon, this.type, this.padding, this.borderRadius, this.distanceNextLine}) : 
        assert(title != null),
        assert(height != null),
        assert(color != null),
        assert(hint != null),
        assert(icon != null),
        assert(padding != null),
        assert(borderRadius != null);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: TextStyle(
            color: widget.color,
            fontWeight: FontWeight.bold,
            fontFamily: defaultFont,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: widget.height,
          child: TextField(
            obscureText: (widget.type == null),
            keyboardType: widget.type,
            style: TextStyle(
              color: widget.color,
              fontFamily: defaultFont,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: widget.padding,
              prefixIcon: Icon(
                widget.icon,
                color: widget.color,
              ),
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: widget.color,
                fontFamily: defaultFont,
              ),
            ),
          ),
        ),
        SizedBox(height: (widget.distanceNextLine == null) ? 0.0 : widget.distanceNextLine)
      ],
    );
  }
}