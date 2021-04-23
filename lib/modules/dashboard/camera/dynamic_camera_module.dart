import 'dart:io';
import 'package:camera/camera.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/app_config.dart';
import 'package:parkinson_de_bolso/config/asset_config.dart';
import 'package:parkinson_de_bolso/config/camera_config.dart';
import 'package:parkinson_de_bolso/config/theme_config.dart';
import 'package:parkinson_de_bolso/model/patient_classification_model.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/camera/dynamic_camera_linear_bar.dart';
import 'package:parkinson_de_bolso/modules/dashboard/camera/usageInformation/usage_information.dart';
import 'package:parkinson_de_bolso/service/patient_classification_service.dart';
import 'package:parkinson_de_bolso/service/predict_service.dart';
import 'package:parkinson_de_bolso/modules/dashboard/camera/dynamic_camera_button.dart';
import 'package:parkinson_de_bolso/util/shared_preferences_util.dart';
import 'package:parkinson_de_bolso/widget/custom_alert_box.dart';
import 'package:parkinson_de_bolso/widget/custom_alert_fade.dart';
import 'package:parkinson_de_bolso/widget/custom_back_button.dart';
import 'package:parkinson_de_bolso/widget/custom_checkbox.dart';
import 'package:parkinson_de_bolso/widget/custom_circular_progress.dart';

enum DynamicCameraType { IMAGE, VIDEO }

class DynamicCameraModule extends StatefulWidget {
  final Color barColor;
  final DynamicCameraType type;
  final PatientModel patient;

  DynamicCameraModule(
      {Key key,
      this.barColor = Colors.black,
      @required this.type,
      this.patient})
      : super(key: key);

  @override
  _DynamicCameraModuleState createState() => _DynamicCameraModuleState();

  static Future<File> takePicture(BuildContext context) async {
    return await DynamicCameraModule._call(context, DynamicCameraType.IMAGE);
  }

  static Future<void> processImageSequence(
      BuildContext context, PatientModel patientModel) async {
    await DynamicCameraModule._call(context, DynamicCameraType.VIDEO,
        patientModel: patientModel);
  }

  static Future<dynamic> _call(
      BuildContext context, DynamicCameraType cameraType,
      {PatientModel patientModel}) async {
    return await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DynamicCameraModule(type: cameraType, patient: patientModel);
    }));
  }
}

class _DynamicCameraModuleState extends State<DynamicCameraModule>
    with TickerProviderStateMixin, SharedPreferencesUtil {
  // control status of the dynamic camera
  CountDownController _countDownController;
  AnimationController _alertErrorController;
  bool _stop,
      _loading,
      _runnig,
      _alert,
      _usageGuidance,
      _recordingType,
      _finalNewsletter;
  Future _initializeControllerFuture;
  PredictService _predictService;
  CameraController _controller;
  DynamicCameraType _type;
  String _messageError, _messageFinalNewsletter;
  File _image;

  // dynamic camera button states
  VoidCallback _cameraButtonOnPressed,
      _cameraButtonOnStart,
      _cameraButtonOnComplete;
  String _cameraButtonTooltip, _cameraButtonLabel;
  Color _cameraButtonBackground;
  IconData _cameraButtonIcon;

  // dynamic linear progression state
  double _linearBarValue;

  @override
  void initState() {
    this._alertErrorController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    this._controller =
        CameraController(CameraConfig.instance.camera, ResolutionPreset.max);
    this._initializeControllerFuture = this._controller.initialize();
    this._countDownController = CountDownController();
    this._predictService = PredictService.instance;
    this._type = this.widget.type;
    this._stop = true;
    this._loading = false;
    this._runnig = false;
    this._alert = false;
    this._finalNewsletter = false;
    this._recordingType = false;
    this._usageGuidance = this.widget.type == DynamicCameraType.VIDEO &&
        AppConfig.instance.usageGuidance;
    this._linearBarValue = 0.0;
    this._messageFinalNewsletter = '';
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
            child: this._buildDynamicCamera()),
      ),
    );
  }

  Widget _buildWalkTypeCard(
      String assetName, String title, double width, bool isCollection) {
    return GestureDetector(
      onTap: () {
        this.setState(() => this._recordingType = false);
        this.startShooting(isCollection);
      },
      child: Container(
        width: 100,
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: ThemeConfig.primaryColor)),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Image(
              image: AssetConfig.instance.get(assetName),
              width: width,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(color: ThemeConfig.primaryColor),
            )
          ],
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
          child: (this._image != null)
              ? null
              : FutureBuilder(
                  future: this._initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(this._controller);
                    } else {
                      return Center(
                          child: CustomCircularProgress(
                        valueColor: ThemeConfig.primaryColor,
                      ));
                    }
                  },
                ),
        ),
        CustomBackButton(
          backgroundColor: ThemeConfig.primaryColor,
          iconColor: ThemeConfig.ternaryColor,
          paddingValue: 20,
          onPressed: () =>
              (this._type != null) ? Navigator.pop(context) : this._reset(),
          visible: !this._alert &&
              !this._usageGuidance &&
              !this._recordingType &&
              !this._finalNewsletter,
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
          visible: !this._alert &&
              !this._usageGuidance &&
              !this._recordingType &&
              !this._finalNewsletter,
        ),
        if (this._type == DynamicCameraType.VIDEO)
          DynamicCameraLinearBar(
            porcentage: this._linearBarValue,
            visible: !this._stop && this._linearBarValue > 0,
          ),
        CustomAlertBox(
          title: 'Informativo',
          visible: this._finalNewsletter,
          close: () => this.setState(() => this._finalNewsletter = false),
          element: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              this._messageFinalNewsletter,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        CustomAlertBox(
          title: 'Tipo de gravação',
          visible: this._recordingType,
          close: () => this.setState(() => this._recordingType = false),
          element: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  this._buildWalkTypeCard('walkOne', 'Perfil', 50, false),
                  this._buildWalkTypeCard('walkTwo', 'Frontal', 60, true)
                ],
              ),
              SizedBox(height: 5),
              Text(
                'A gravação frontal está em fase de coleta de imagem sem retornar a porcentagem de Parkinson',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ThemeConfig.primaryColor,
                ),
              )
            ],
          ),
        ),
        CustomAlertBox(
          title: 'Orientações de uso',
          element: UsageInformation(),
          visible: this._usageGuidance,
          close: () {
            if (!AppConfig.instance.usageGuidance) {
              this.addPrefs('usage_guidance', 'no');
            }

            this.setState(() {
              this._usageGuidance = false;
            });
          },
          extra: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomCheckbox(
                activeColor: ThemeConfig.primaryColor,
                checkColor: ThemeConfig.ternaryColor,
                caption: 'Não mostrar novamente?',
                height: 30,
                remember: (status) =>
                    {AppConfig.instance.usageGuidance = !status},
              )
            ],
          ),
        ),
        CustomAlertBox(
          title: 'Resultado Fictício',
          content: 'Taxa de Parkinson',
          valueContent: this._linearBarValue.toInt().toString() + '%',
          visible: this._alert,
          buttons: [
            CustomButtonAlertBox(Icons.thumb_up, 'Marcar como acerto', () {
              this.setState(() {
                this._alert = false;
                this._loading = true;
              });
              PatientClassificationService.instance
                  .create(PatientClassificationModel(
                      patientid: this.widget.patient.id,
                      percentage: this._linearBarValue))
                  .then((_) => this.setState(() {
                        Navigator.pop(context);
                      }))
                  .whenComplete(
                      () => this.setState(() => this._loading = false));
            }, ThemeConfig.primaryColor),
            CustomButtonAlertBox(Icons.thumb_down, 'Marcar como erro',
                () => this.setState(() => this._alert = false), Colors.red[900])
          ],
        ),
        CustomAlertFade(
            controller: this._alertErrorController, message: this._messageError)
      ],
    );
  }

  BoxDecoration _getDecoration() {
    if (this._image != null) {
      return BoxDecoration(
          image: DecorationImage(
              image: FileImage(this._image), fit: BoxFit.cover));
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
        this._cameraButtonOnPressed =
            () => this.setState(() => this._recordingType = true);
        this._cameraButtonTooltip = 'Filmar';
        this._cameraButtonOnStart = () {
          this.setState(() => this._stop = false);
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
      this._loading = false;
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

  void startShooting(bool isCollection) async {
    try {
      if (!this._runnig) {
        // execution started
        this.setState(() => this._runnig = true);

        // create a run id
        String _predictId = await this._predictService.getId();

        // initializes the screen timer
        await this._countdown(3);
        await this._initializeControllerFuture;
        this._countDownController.start();
        int _imageCounter = 0;
        XFile _capture;

        while (!this._stop) {
          _capture = await this._controller.takePicture();
          this
              ._predictService
              .evaluator(_predictId, this.widget.patient.id, _imageCounter++,
                  _capture, isCollection)
              .then((Map response) {
            if (response != null)
              this.setState(() => this._linearBarValue =
                  double.tryParse(response['percentage']));
          });
          await Future.delayed(Duration(seconds: 1));
        }

        if (isCollection) {
          this.setState(() {
            this._finalNewsletter = true;
            this._messageFinalNewsletter =
                'Coleta efetuada com sucesso, muito obrigado pela ajuda!';
          });
        } else {
          final Map _conclude = await this._predictService.conclude(_predictId);
          if (_conclude != null) {
            double porcentage = double.tryParse(_conclude['percentage']);
            if (porcentage > 0) {
              this.setState(() {
                this._linearBarValue = porcentage;
                this._alert = true;
              });
            } else {
              this.setState(() {
                this._finalNewsletter = true;
                this._messageFinalNewsletter =
                    'Paciente sem características de Parkinson!';
              });
            }
          }
        }
      }
    } catch (error) {
      this._reset();
    }
  }

  Future _countdown(int timer) async {
    while (timer > 0) {
      this.setState(() => this._cameraButtonLabel = timer.toString());
      timer--;
      await Future.delayed(Duration(seconds: 1));
    }
  }

  void _activateStopButton() {
    this.setState(() {
      this._cameraButtonLabel = null;
      this._cameraButtonIcon = Icons.pause;
      this._cameraButtonBackground = Colors.red;
      this._cameraButtonOnPressed = () {
        this._stop = true;
        this._reset();
      };
      this._cameraButtonTooltip = 'Cancelar';
    });
  }

  void printError(String error) {
    this.setState(() => this._messageError = error);
    this._alertErrorController.forward();
  }
}
