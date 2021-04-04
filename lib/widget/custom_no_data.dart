import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme_config.dart';

class CustomNoData extends StatelessWidget {
  final ImageProvider image;
  final String message;
  final Color color;

  CustomNoData(
      {this.image, this.message = 'Sem dados para a exibição', this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            this.message,
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w800,
              color: this.color == null ? ThemeConfig.primaryColor : this.color,
            ),
          ),
          Image(
            image: this.image,
            height: 300,
          )
        ],
      ),
    );
  }
}
