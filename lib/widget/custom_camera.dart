import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/camera_handler.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';

class CustomCamera extends StatefulWidget {
  static const String routeName = '/camera';
  CustomCamera({ Key key }) : super(key: key);

  @override
  _CustomCameraState createState() => _CustomCameraState();

}

class _CustomCameraState extends State<CustomCamera> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;  
  
  @override
  void initState() {
    super.initState();
    this._controller = CameraController(CameraHandler.instance.getCamera(), ResolutionPreset.medium);
    this._initializeControllerFuture = this._controller.initialize();
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                child: FutureBuilder(
                  future: this._initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(this._controller);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )
              ),
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          child: RaisedButton(
                            highlightColor: Colors.red,
                            color: Colors.white,
                            hoverColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(
                                  color: Colors.black.withOpacity(0.5),
                                  width: 4
                                )
                            ),
                            onPressed: () {},
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Take a picture')),
  //     body: FutureBuilder(
  //       future: this._initializeControllerFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           return CameraPreview(this._controller);
  //         } else {
  //           return Center(child: CircularProgressIndicator());
  //         }
  //       },
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       child: Icon(Icons.camera_alt),
  //       onPressed: () async {
  //         try {
  //           await this._initializeControllerFuture;
  //           XFile file = await this._controller.takePicture();
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayPicture(imagePath: file.path)));
  //         } catch(e) {
  //           print(e);
  //         }
  //       },
  //     ),
  //   );
  // }
}

class DisplayPicture  extends StatelessWidget {
  final String imagePath;
  
  DisplayPicture({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the picture')),
      body: Image.file(File(this.imagePath)),
    );
  }
}