import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/http_constant.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double radius;
  final Color background;
  final Color foreground;
  final String imagePath;
  final String initials;

  CustomCircleAvatar({@required this.radius, @required this.background, @required this.foreground, this.imagePath, this.initials});

  Widget _buildInitials() {
    return Text(
      this.initials,
      style: TextStyle(
        fontSize: this.radius
      ),
    );
  }

  Widget _buildImage() {
    return CircleAvatar(
      radius: this.radius,
      backgroundImage: NetworkImage(image_host + this.imagePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: this.radius,
      backgroundColor: this.background,
      foregroundColor: this.foreground,
      child: (this.imagePath != null) ? this._buildImage() : this._buildInitials(),
    );
  }

}