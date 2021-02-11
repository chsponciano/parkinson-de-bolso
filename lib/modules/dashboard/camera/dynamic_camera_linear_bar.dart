import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';

class DynamicCameraLinearBar extends StatelessWidget {
  final double porcentage;
  final bool visible;

  const DynamicCameraLinearBar({Key key, this.porcentage = 0.0, this.visible = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: this.visible,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FAProgressBar(
            currentValue: this.porcentage.toInt(),
            displayText: '%',
            direction: Axis.vertical,
            verticalDirection: VerticalDirection.up,
            progressColor: primaryColor,
          ),
        ),
      ),
    );
  }
}