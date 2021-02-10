import 'dart:io';
import 'package:camera/camera.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/camera_handler.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/modules/dashboard/camera/dynamic_camera_linear_bar.dart';
import 'package:parkinson_de_bolso/service/predict_service.dart';
import 'package:parkinson_de_bolso/modules/dashboard/camera/dynamic_camera_button.dart';
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
  CountDownController _countDownController;
  Future _initializeControllerFuture;  
  PredictService _predictService;
  CameraController _controller;
  DynamicCameraType _type;
  
  // Camera Button
  String _tooltip;
  Color _backgroundColor;
  IconData _icon;
  VoidCallback _onPressed;
  VoidCallback _onStart;
  VoidCallback _onComplete;
  String _companionLabel;

  // Liner bar
  double _porcentage = 0.0;

  File _image;
  bool _stop, _loading, _runnig;
  int _count = 0;

  @override
  void initState() {
    this._controller = CameraController(CameraHandler.instance.camera, ResolutionPreset.max);
    this._initializeControllerFuture = this._controller.initialize();
    this._countDownController = CountDownController();
    this._predictService = PredictService.instance;
    this._type = this.widget.type;
    this._stop = false;
    this._loading = false;
    this._runnig = false;

    super.initState();
    this._loadButtonConfiguration();
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

        DynamicCameraButton(
          countDownController: this._countDownController, 
          tooltip: this._tooltip,
          backgroundColor: this._backgroundColor,
          icon: this._icon,
          onPressed: this._onPressed,
          companionLabel: this._companionLabel,
          onStart: this._onStart,
          onComplete: this._onComplete,
          isLoading: this._loading,
        ),

        if (this._type == DynamicCameraType.VIDEO)
          DynamicCameraLinearBar(
            porcentage: this._porcentage,
          ),
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

  void _loadButtonConfiguration() {  
    switch (this._type) {
      case DynamicCameraType.IMAGE:
        this._icon = Icons.camera_alt;
        this._onPressed = () => this.takePicture();
        this._tooltip = 'Capturar';
        break;
      case DynamicCameraType.VIDEO:
        this._icon = Icons.videocam;
        this._onPressed = () => this.startShooting();
        this._tooltip = 'Filmar';
        this._onStart = () {
          this.setState(() => this._stop = false);
          this._activateStopButton();
        };
        this._onComplete = () {
          this.setState(() => this._stop = true);
          this._reset();
        };
        break;
      default:
        this._icon = Icons.done;
        this._onPressed = () => Navigator.pop(context, this._image);
        this._tooltip = 'Confirmar';
        break;
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
          onPressed: () => (this._type != null) ? Navigator.pop(context) : this._reset(),
        ),
      ),
    );
  }

  void _reset() {
    this.setState(() {
      this._runnig = false;
      this._type = this.widget.type;
      this._image = null;
      this._count = 0;
      this._backgroundColor = null;
      this._companionLabel = null;
    });
    this._countDownController.pause();
    this._loadButtonConfiguration();
  }

  void takePicture() async {
    await this._initializeControllerFuture;
    XFile file = await this._controller.takePicture();
    this.setState(() {
      this._image = File(file.path);
      this._type = null;
    });
    this._loadButtonConfiguration();
  }

  void startShooting() async {
    try {
      if (!this._runnig) { 
        this.setState(() {
          this._runnig = true;
          this._loading = true;
        });

        Map init = await this._predictService.initialize();
        print(init);

        this.setState(() => this._loading = false);

        await this._countdown(3);
        await this._initializeControllerFuture;
        this._countDownController.start();      
        
        while(!this._stop) {
          XFile file = await this._controller.takePicture();
          this._predictService.evaluator(this._count, file).then((value) => _porcentage = double.parse(value['porcentage'].toString()));
          this.setState(() => this._count++);
          await Future.delayed(Duration(seconds: 1));
        }

        Map data = await this._predictService.conclude();
        print(data);
      }
    } catch (error)  {
      print(error);
    }
  }

  Future _countdown(int timer) async {
    while(timer > 0) {
      this.setState(() => this._companionLabel = timer.toString());
      timer--;
      await Future.delayed(Duration(seconds: 1));
    }
  }

  void _activateStopButton() {
    this.setState(() {
      this._stop = false;
      this._companionLabel = null;
      this._icon = Icons.pause;
      this._backgroundColor = Colors.red;
      this._onPressed = () => this._reset();
      this._tooltip = 'Cancelar';
    });
  }  
}