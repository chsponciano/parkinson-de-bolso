import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TitlePage extends StatelessWidget {
  String title;
  Color color;
  double distanceNextLine;
  bool addIcon;

  TitlePage({this.title, this.color, this.distanceNextLine, this.addIcon = false}) : 
    assert(title != null),
    assert(color != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (this.addIcon)
          Image(
            image: AssetImage('assets/images/icon.png'),
            height: 120,
          ),
          SizedBox(height: 15),
        Text(
          this.title,
          style: TextStyle(
            color: this.color,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (this.distanceNextLine != null)
          SizedBox(height: this.distanceNextLine)
      ],
    );
  }
}
