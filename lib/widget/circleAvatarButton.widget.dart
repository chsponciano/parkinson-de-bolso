import 'dart:io';
import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/modules/camera/camera.page.dart';
import 'package:parkinson_de_bolso/type/module.type.dart';

class CircleAvatarButtonWidget extends StatefulWidget {
  final Color background;
  final Color foreground;
  final double radius;
  final IconData icon;
  final File image;
  final String imageUrl;
  final Function setImage;

  CircleAvatarButtonWidget({
    @required this.background,
    @required this.foreground,
    @required this.radius,
    @required this.icon,
    this.image,
    this.imageUrl,
    @required this.setImage,
  });

  @override
  _CircleAvatarButtonWidgetState createState() =>
      _CircleAvatarButtonWidgetState();
}

class _CircleAvatarButtonWidgetState extends State<CircleAvatarButtonWidget> {
  File _image;

  @override
  void initState() {
    if (this.widget.image != null) {
      this._image = this.widget.image;
    }
    super.initState();
  }

  Future getImage() async {
    AppConfig.instance.changeModule(ModuleType.CAMERA);
    final image = await CameraPage.takePicture(context);
    AppConfig.instance.changeModule(ModuleType.DASHBOARD);
    this._reloadImage(image);
  }

  void _reloadImage(image) {
    this.setState(() => this._image = image);
    Function.apply(this.widget.setImage, [image]);
  }

  Widget _buildIcon() {
    if (this.widget.imageUrl != null) {
      return CircleAvatar(
        radius: this.widget.radius,
        backgroundImage: NetworkImage(this.widget.imageUrl),
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
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          GestureDetector(
              onTap: () => this.getImage(),
              child: CircleAvatar(
                radius: this.widget.radius,
                child: Center(
                    child: (this._image == null)
                        ? this._buildIcon()
                        : this._buildImage()),
                backgroundColor: this.widget.background,
                foregroundColor: this.widget.foreground,
              )),
          Visibility(
            visible: this.widget.image != null || this.widget.imageUrl != null,
            child: GestureDetector(
              onTap: () => this._reloadImage(null),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: ThemeConfig.primaryColor,
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  Icons.close,
                  color: ThemeConfig.ternaryColor,
                  size: 25,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
