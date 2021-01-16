import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/assest_path.dart';

// ignore: must_be_immutable
class CustomTitlePage extends StatelessWidget {
  @required String title;
  @required Color color;
  double distanceNextLine;
  bool addIcon;

  CustomTitlePage({this.title, this.color, this.distanceNextLine, this.addIcon = false}) : 
    assert(title != null),
    assert(color != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (this.addIcon)
          Image(
            image: AssetImage(icon),
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
