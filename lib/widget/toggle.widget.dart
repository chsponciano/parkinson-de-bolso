import 'package:flutter/material.dart';

class ToggleWidget extends StatefulWidget {
  final Function action;
  final Color background;
  final Color trackColor;
  final String label;
  final bool initial;

  const ToggleWidget({
    Key key,
    this.action,
    this.background,
    this.trackColor,
    this.label,
    this.initial = false,
  }) : super(key: key);

  @override
  _ToggleWidgetState createState() => _ToggleWidgetState();
}

class _ToggleWidgetState extends State<ToggleWidget> {
  bool _isActive;

  @override
  void initState() {
    this._isActive = this.widget.initial;
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
              print(status);
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
