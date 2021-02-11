import 'dart:io';
import 'package:camera/camera.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/camera_config.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/active_classification_model.dart';
import 'package:parkinson_de_bolso/model/execution_classification_model.dart';
import 'package:parkinson_de_bolso/model/patient_classification_model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/camera/dynamic_camera_linear_bar.dart';
import 'package:parkinson_de_bolso/service/predict_service.dart';
import 'package:parkinson_de_bolso/modules/dashboard/camera/dynamic_camera_button.dart';
import 'package:parkinson_de_bolso/widget/custom_alert_box.dart';
import 'package:parkinson_de_bolso/widget/custom_back_button.dart';
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
  // control status of the dynamic camera
  CountDownController _countDownController;
  bool _stop, _loading, _runnig, _alert;
  Future _initializeControllerFuture;  
  PredictService _predictService;
  CameraController _controller;
  DynamicCameraType _type;  
  File _image;

  // dynamic camera button states
  VoidCallback _cameraButtonOnPressed, _cameraButtonOnStart, _cameraButtonOnComplete;
  String _cameraButtonTooltip, _cameraButtonLabel;
  Color _cameraButtonBackground;
  IconData _cameraButtonIcon;

  // dynamic linear progression state
  double _linearBarValue;


  @override
  void initState() {
    this._controller = CameraController(CameraHandler.instance.camera, ResolutionPreset.max);
    this._initializeControllerFuture = this._controller.initialize();
    this._countDownController = CountDownController();
    this._predictService = PredictService.instance;
    this._type = this.widget.type;
    this._stop = true;
    this._loading = false;
    this._runnig = false;
    this._alert = false;
    this._linearBarValue = 0.0;

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

        CustomBackButton(
          backgroundColor: primaryColor,
          iconColor: ternaryColor,
          paddingValue: 20,
          onPressed: () => (this._type != null) ? Navigator.pop(context) : this._reset(),
          visible: !this._alert,
        ),

        DynamicCameraButton(
          countDownController: this._countDownController, 
          tooltip: this._cameraButtonTooltip,
          backgroundColor: this._cameraButtonBackground,
          icon: this._cameraButtonIcon,
          onPressed: this._cameraButtonOnPressed,
          companionLabel: this._cameraButtonLabel,
          onStart: this._cameraButtonOnStart,
          onComplete: this._cameraButtonOnComplete,
          isLoading: this._loading,
          visible: !this._alert,
        ),

        if (this._type == DynamicCameraType.VIDEO)
          DynamicCameraLinearBar(
            porcentage: this._linearBarValue,
            visible: !this._stop,
          ),
          CustomAlertBox(
            title: 'Resultado',
            content: 'Taxa de Parkinson',
            valueContent: this._linearBarValue.toString(),
            visible: this._alert,
            buttons: [
              CustomButtonAlertBox(
                Icons.thumb_up, 
                'Marcar como acerto', 
                () => this.setState(() => this._alert = false), 
                primaryColor
              ),
              CustomButtonAlertBox(
                Icons.thumb_down, 
                'Marcar como erro', 
                () => this.setState(() => this._alert = false),
                Colors.red[900]
              )
            ],
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
        this._cameraButtonIcon = Icons.camera_alt;
        this._cameraButtonOnPressed = () => this.takePicture();
        this._cameraButtonTooltip = 'Capturar';
        break;
      case DynamicCameraType.VIDEO:
        this._cameraButtonIcon = Icons.videocam;
        this._cameraButtonOnPressed = () => this.startShooting();
        this._cameraButtonTooltip = 'Filmar';
        this._cameraButtonOnStart = () {
          this.setState(() {
            this._stop = false;
            this._linearBarValue = 50.0;
          });
          this._activateStopButton();
        };
        this._cameraButtonOnComplete = () {
          this.setState(() => this._stop = true);
          this._reset();
        };
        break;
      default:
        this._cameraButtonIcon = Icons.done;
        this._cameraButtonOnPressed = () => Navigator.pop(context, this._image);
        this._cameraButtonTooltip = 'Confirmar';
        break;
    }
  }

  void _reset() {
    this.setState(() {
      this._runnig = false;
      this._type = this.widget.type;
      this._image = null;
      this._cameraButtonBackground = null;
      this._cameraButtonLabel = null;
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

        final ActiveClassificationModel _activePatient = await this._predictService.initialize();

        if (_activePatient != null) {
          this.setState(() => this._loading = false);
          await this._countdown(3);
          await this._initializeControllerFuture;
          this._countDownController.start();   
          
          int _imageCounter = 0;
          XFile _capture;
          
          while(!this._stop) {
            _capture = await this._controller.takePicture();
            this._predictService.evaluator(_imageCounter++, _capture).then((ExecutionClassificationModel execution) {
              if (execution != null)
                this.setState(() => this._linearBarValue = execution.percentage);
            });
            await Future.delayed(Duration(seconds: 1));
          }

          // final PatientClassificationModel _patientClassification = await this._predictService.conclude();

          // if (_patientClassification != null) {
          //   this.setState(() {
          //     this._linearBarValue = _patientClassification.percentage;
          //     this._alert = true;
          //   });
          // }

          if (true) {
            this.setState(() {
              this._alert = true;
            });
          }
        }
      }
    } catch (error)  {
      this._reset();
    }
  }

  Future _countdown(int timer) async {
    while(timer > 0) {
      this.setState(() => this._cameraButtonLabel = timer.toString());
      timer--;
      await Future.delayed(Duration(seconds: 1));
    }
  }

  void _activateStopButton() {
    this.setState(() {
      this._stop = false;
      this._cameraButtonLabel = null;
      this._cameraButtonIcon = Icons.pause;
      this._cameraButtonBackground = Colors.red;
      this._cameraButtonOnPressed = () => this._reset();
      this._cameraButtonTooltip = 'Cancelar';
    });
  }  
}