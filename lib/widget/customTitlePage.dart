import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTitlePage extends StatefulWidget {
  String title;
  Color color;
  double distanceNextLine;
  bool addIcon;

  CustomTitlePage({this.title, this.color, this.distanceNextLine, this.addIcon = false}) : 
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
        if (widget.addIcon)
          Image(
            image: AssetImage('assets/images/icon.png'),
            height: 120,
          ),
          SizedBox(height: 15),
        Text(
          widget.title,
          style: TextStyle(
            color: widget.color,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.distanceNextLine != null)
          SizedBox(height: widget.distanceNextLine)
      ],
    );
  }
}
