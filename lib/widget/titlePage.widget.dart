import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';

class TitlePageWidget extends StatelessWidget {
  final String title;
  final Color color;
  final double distanceNextLine;
  final bool addIcon;

  TitlePageWidget({
    @required this.title,
    @required this.color,
    this.distanceNextLine,
    this.addIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (this.addIcon)
          Image(
            image: AppConfig.instance.assetConfig.get('icon'),
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
          SizedBox(
            height: this.distanceNextLine,
          )
      ],
    );
  }
}
