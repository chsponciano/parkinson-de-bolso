import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';

class CustomErrorBox extends StatelessWidget {
  final String message;

  CustomErrorBox({@required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: errorBoxColor,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Text(
          this.message,
          style: TextStyle(
            color: ternaryColor
          ),
        )
      ),
    );
  }

}