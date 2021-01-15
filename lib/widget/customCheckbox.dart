import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomCheckbox extends StatefulWidget {
  Color checkColor;
  Color activeColor;
  String caption;
  double height;

  CustomCheckbox({this.checkColor, this.activeColor, this.caption, this.height}) :
    assert(checkColor != null),
    assert(activeColor != null),
    assert(caption != null),
    assert(height != null);

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: widget.activeColor),
            child: Checkbox(
              value: _isChecked,
              checkColor: widget.checkColor,
              activeColor: widget.activeColor,
              onChanged: (value) {
                setState(() {
                  _isChecked = value;
                });
              },
            ),
          ),
          Text(
            widget.caption,
            style: TextStyle(
              color: widget.activeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}