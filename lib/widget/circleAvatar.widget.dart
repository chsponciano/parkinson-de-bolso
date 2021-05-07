import 'package:flutter/material.dart';

class CircleAvatarWidget extends StatelessWidget {
  final double radius;
  final Color background;
  final Color foreground;
  final String imagePath;

  CircleAvatarWidget({
    @required this.radius,
    @required this.background,
    @required this.foreground,
    this.imagePath,
  });

  Widget _buildIcon() {
    return Icon(
      Icons.person,
      size: radius,
    );
  }

  Widget _buildImage() {
    return CircleAvatar(
      radius: this.radius,
      backgroundImage: NetworkImage(this.imagePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: this.radius,
      backgroundColor: this.background,
      foregroundColor: this.foreground,
      child: (this.imagePath != null) ? this._buildImage() : this._buildIcon(),
    );
  }
}
