import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkinson_de_bolso/constant/http_constant.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CustomCircleAvatarButton extends StatefulWidget {
  final Color background;
  final Color foreground;
  final double radius;
  final IconData icon;
  final File image;
  final String imageUrl;
  final Function setImage;

  CustomCircleAvatarButton({@required this.background, @required this.foreground, @required this.radius, @required this.icon, this.image, this.imageUrl, @required this.setImage});

  @override
  _CustomCircleAvatarButtonState createState() => _CustomCircleAvatarButtonState();
}

class _CustomCircleAvatarButtonState extends State<CustomCircleAvatarButton> {
  File _image;
  
  @override
  void initState() {
    if (this.widget.image != null) {
      this._image = this.widget.image;
    }
    super.initState();
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this._image = image;
    });
    
    Function.apply(this.widget.setImage, [image]);
  }

  Widget _buildIcon() {
    if (this.widget.imageUrl != null) {
      return CircleAvatar (
        radius: this.widget.radius,
        backgroundImage: NetworkImage(image_host + this.widget.imageUrl),
      );
    }

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