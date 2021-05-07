import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final Color checkColor;
  final Color activeColor;
  final String caption;
  final double height;
  final Function remember;

  CheckboxWidget({
    @required this.checkColor,
    @required this.activeColor,
    @required this.caption,
    @required this.height,
    @required this.remember,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CheckboxWidget> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(
              unselectedWidgetColor: widget.activeColor,
            ),
            child: Checkbox(
              value: _isChecked,
              checkColor: widget.checkColor,
              activeColor: widget.activeColor,
              onChanged: (value) {
                setState(() {
                  _isChecked = value;
                });
                this.widget.remember(value);
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
