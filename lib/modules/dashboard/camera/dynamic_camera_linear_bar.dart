import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class DynamicCameraLinearBar extends StatelessWidget {
  final double porcentage;

  const DynamicCameraLinearBar({Key key, this.porcentage = 0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FAProgressBar(
          currentValue: this.porcentage.toInt(),
          displayText: '%',
          direction: Axis.vertical,
          verticalDirection: VerticalDirection.up,
        ),
      ),
    );
  }
}