import 'package:flutter/material.dart';

class CustomToggle extends StatefulWidget {
  final Function action;
  final Color background;
  final Color trackColor;
  final String label;

  const CustomToggle({Key key, this.action, this.background, this.trackColor, this.label}) : super(key: key);

  @override
  _CustomToggleState createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  bool _isActive;

  @override
  void initState() {
    this._isActive = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [ 
        Switch(
          value: this._isActive,
          onChanged: (status) {
            this.setState(() {
              this._isActive = status;
              Function.apply(this.widget.action, [status]);
            });
          },
          activeTrackColor: this.widget.trackColor,
          activeColor: this.widget.background,
        ),
        Text(
          this.widget.label,
          style: TextStyle(
            color: this.widget.background,
            fontSize: 15,
          ),
        )
      ],
    );
  }
}