import 'package:flutter/material.dart';
import 'dart:math';

class CustomTimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  CustomTimerPainter({this.animation, this.backgroundColor, this.color}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = this.backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = this.color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomTimerPainter  oldDelegate) {
    return this.animation.value != oldDelegate.animation.value ||
           this.color != oldDelegate.color ||
           this.backgroundColor != oldDelegate.backgroundColor;
  }

}