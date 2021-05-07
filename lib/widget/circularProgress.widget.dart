import 'package:flutter/material.dart';

class CircularProgressWidget extends StatelessWidget {
  final Color valueColor;

  CircularProgressWidget({
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(this.valueColor),
      ),
    );
  }
}
