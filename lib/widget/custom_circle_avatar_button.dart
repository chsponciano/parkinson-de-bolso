import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomCircleAvatarButton extends StatefulWidget {
  final Color background;
  final Color foreground;
  final double radius;
  final IconData icon;

  CustomCircleAvatarButton({@required this.background, @required this.foreground, @required this.radius, @required this.icon});

  @override
  CustomCircleAvatarButtonState createState() => CustomCircleAvatarButtonState();
}

class CustomCircleAvatarButtonState extends State<CustomCircleAvatarButton> {
  File _image;

  Future getImage() async {
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this._image = image;
    });
  }

  Widget _buildIcon() {
    return Icon(
      this.widget.icon,
      size: this.widget.radius,
    );
  }

  Widget _buildImage() {
    return CircleAvatar(
      radius: this.widget.radius,
      backgroundImage: FileImage(this._image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => this.getImage(),
        child: CircleAvatar(
          radius: this.widget.radius,
          child: Center(
            child: (this._image == null) ? this._buildIcon() : this._buildImage()
          ),
          backgroundColor: this.widget.background,
          foregroundColor: this.widget.foreground,
        )
      ),
    );
  }
}