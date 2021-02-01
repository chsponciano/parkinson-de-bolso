import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/camera_handler.dart';
import 'package:parkinson_de_bolso/widget/custom_round_buttom.dart';

class CustomCamera extends StatefulWidget {
  static const String routeName = '/camera';
  final Color barColor;

  CustomCamera({ Key key, this.barColor = Colors.black }) : super(key: key);

  @override
  _CustomCameraState createState() => _CustomCameraState();

}

class _CustomCameraState extends State<CustomCamera> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;  
  File _image;
  
  @override
  void initState() {
    super.initState();
    this._controller = CameraController(CameraHandler.instance.camera, ResolutionPreset.max);
    this._initializeControllerFuture = this._controller.initialize();
  }

  @override
  void dispose() {
    this._controller.dispose();
    this._image = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: this.widget.barColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 40,
        leading: IconButton(
          icon: Icon(Icons.close), 
          onPressed: () => Navigator.pop(context)
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              this._buildMainScene(),
              this._buildBar()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainScene() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: (this._image != null) ? BoxDecoration(
        image: DecorationImage(
          image: FileImage(this._image),
          fit: BoxFit.cover
        )
      ) : null,
      child: (this._image != null) ? null : FutureBuilder(
        future: this._initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(this._controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }

  Widget _buildBar() {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: this.widget.barColor.withOpacity(0.5),
      ),
      child: AnimatedCrossFade(
        firstChild: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.replay),
                color: Colors.white,
                iconSize: 50,
                onPressed: () => this.setState(() => this._image = null),
              ),
              IconButton(
                icon: Icon(Icons.done),
                color: Colors.white,
                iconSize: 50,
                onPressed: () => Navigator.pop(context, this._image),
              ),
            ],
          ),
        ), 
        secondChild: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomRoundButton(
              width: 60, 
              color: Colors.white, 
              highlightColor: Colors.red, 
              onPressed: () => this.takePicture()
            ),
          ],
        ), 
        crossFadeState: this._image != null ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
        duration: Duration(milliseconds: 300)
      ),
    );
  }

  void takePicture() async {
    await this._initializeControllerFuture;
    XFile file = await this._controller.takePicture();
    this.setState(() => this._image = File(file.path));
  }
}