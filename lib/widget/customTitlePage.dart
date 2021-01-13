import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTitlePage extends StatefulWidget {
  String title;
  Color color;
  double distanceNextLine;

  CustomTitlePage({this.title, this.color, this.distanceNextLine}) : 
    assert(title != null),
    assert(color != null);

  @override
  _CustomTitlePageState createState() => _CustomTitlePageState();
}

class _CustomTitlePageState extends State<CustomTitlePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: widget.color,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: (widget.distanceNextLine == null) ? 0.0 : widget.distanceNextLine)
      ],
    );
  }
}
