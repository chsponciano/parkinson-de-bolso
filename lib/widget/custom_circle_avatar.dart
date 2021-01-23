import 'dart:io';

import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double radius;
  final Color background;
  final Color foreground;
  final File image;
  final String initials;

  CustomCircleAvatar({@required this.radius, @required this.background, @required this.foreground, this.image, this.initials});

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
      backgroundImage: FileImage(this.image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: this.radius,
      backgroundColor: this.background,
      foregroundColor: this.foreground,
      child: (this.image != null) ? this._buildImage() : this._buildInitials(),
    );
  }

}