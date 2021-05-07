import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';

class NoDataWidget extends StatelessWidget {
  final ImageProvider image;
  final String message;
  final Color color;

  NoDataWidget({
    this.image,
    this.message = 'Sem dados para a exibição',
    this.color,
  });

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
