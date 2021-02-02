import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/camera_handler.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/widget/custom_circular_progress.dart';

enum DynamicCameraType {
  IMAGE,
  VIDEO
}

class DynamicCameraModule extends StatefulWidget {
  final Color barColor;
  final DynamicCameraType type;

  DynamicCameraModule({ Key key, this.barColor = Colors.black, @required this.type }) : super(key: key);

  @override
  _DynamicCameraModuleState createState() => _DynamicCameraModuleState();

  static Future<File> takePicture(BuildContext context) async {
    return await DynamicCameraModule._call(context, DynamicCameraType.IMAGE);
  }

  static Future<void> processImageSequence(BuildContext context) async {
    await DynamicCameraModule._call(context, DynamicCameraType.VIDEO);
  }

  static Future<dynamic> _call(BuildContext context, DynamicCameraType cameraType) async {
    return await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DynamicCameraModule(type: cameraType);
    }));
  }
}

class _DynamicCameraModuleState extends State<DynamicCameraModule> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;  
  DynamicCameraType _type;
  File _image;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    this._type = this.widget.type;
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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: this._buildDynamicCamera()
        ),
      ),
      floatingActionButton: this._getFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDynamicCamera() {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: this._getDecoration(),
          child: (this._image != null) ? null : FutureBuilder(
            future: this._initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(this._controller);
              } else {
                return Center(
                  child: CustomCircularProgress(
                    valueColor: primaryColor,
                  )
                );
              }
            },
          ),
        ),
        this._buildBackButton(),
        if (this._type == DynamicCameraType.VIDEO)
          this._buildCounter()
      ],
    );
  }

  BoxDecoration _getDecoration() {
    if (this._image != null) {
      return BoxDecoration(
        image: DecorationImage(
          image: FileImage(this._image),
          fit: BoxFit.cover
        )
      );
    }

    return BoxDecoration(color: Colors.black);
  }

  FloatingActionButton _getFloatingActionButton() {
    switch (this._type) {
      case DynamicCameraType.IMAGE:
        return FloatingActionButton(
          backgroundColor: primaryColor,
          child: Icon(Icons.camera_alt),
          onPressed: () => this.takePicture(),
        );
      case DynamicCameraType.VIDEO:
        return FloatingActionButton(
          backgroundColor: primaryColor,
          child: Icon(Icons.videocam),
          onPressed: () => this.setState(() => this._count++)
        );
      default:
        return FloatingActionButton(
          backgroundColor: primaryColor,
          child: Icon(Icons.done),
          onPressed: () => Navigator.pop(context, this._image),
        );
    }
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: primaryColor,
        child: IconButton(
          tooltip: 'Voltar',
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => (this._type != null) ? Navigator.pop(context) : this._resetImage(),
        ),
      ),
    );
  }

  Widget _buildCounter() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text(
              '$_count/100',
              style: TextStyle(
                color: ternaryColor,
                fontSize: 20
              ),
            ),
          )
        ],
      ),
    );
  }

  void _resetImage() {
    this.setState(() {
      this._type = this.widget.type;
      this._image = null;
    });
  }

  void takePicture() async {
    await this._initializeControllerFuture;
    XFile file = await this._controller.takePicture();
    this.setState(() {
      this._image = File(file.path);
      this._type = null;
    });
  }
}