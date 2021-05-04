import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:camera/camera.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/adapter/dialog.adapter.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/asset.config.dart';
import 'package:parkinson_de_bolso/config/camera.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/patient.model.dart';
import 'package:parkinson_de_bolso/modules/camera/extra/camera.button.dart';
import 'package:parkinson_de_bolso/modules/camera/extra/camera.usage.information.dart';
import 'package:parkinson_de_bolso/modules/dashboard/action/dashboard.actions.dart';
import 'package:parkinson_de_bolso/service/predict.service.dart';
import 'package:parkinson_de_bolso/type/camera.type.dart';
import 'package:parkinson_de_bolso/util/sharedPreferences.util.dart';
import 'package:parkinson_de_bolso/widget/custom_back_button.dart';
import 'package:parkinson_de_bolso/widget/custom_checkbox.dart';
import 'package:parkinson_de_bolso/widget/custom_circular_progress.dart';

class CameraPage extends StatefulWidget {
  final Color barColor;
  final CameraType type;
  final PatientModel patient;

  CameraPage(
      {Key key,
      this.barColor = Colors.black,
      @required this.type,
      this.patient})
      : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();

  static Future<File> takePicture(BuildContext context) async {
    return await CameraPage._call(context, CameraType.IMAGE);
  }

  static Future<void> processImageSequence(
      BuildContext context, PatientModel patientModel) async {
    await CameraPage._call(context, CameraType.VIDEO,
        patientModel: patientModel);
  }

  static Future<dynamic> _call(
    BuildContext context,
    CameraType cameraType, {
    PatientModel patientModel,
  }) async {
    // AppConfig.instance.changeModule(ModuleType.CAMERA, null, [], null);
    return await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CameraPage(type: cameraType, patient: patientModel);
    }));
  }
}

class _CameraPageState extends State<CameraPage>
    with TickerProviderStateMixin, SharedPreferencesUtil {
  final DialogAdapter _dialogAdapter = DialogAdapter.instance;

  // control status of the dynamic camera
  CountDownController _countDownController;
  bool _stop, _loading, _runnig;
  Future _initializeControllerFuture;
  PredictService _predictService;
  CameraController _controller;
  CameraType _type;
  File _image;
  int _capturedImagesCounter = 0;
  int _senderImagesCounter = 0;

  // dynamic camera button states
  VoidCallback _cameraButtonOnPressed,
      _cameraButtonOnStart,
      _cameraButtonOnComplete;
  String _cameraButtonTooltip, _cameraButtonLabel;
  Color _cameraButtonBackground;
  IconData _cameraButtonIcon;

  @override
  void initState() {
    this._controller =
        CameraController(CameraConfig.instance.camera, ResolutionPreset.max);
    this._initializeControllerFuture = this._controller.initialize();
    this._countDownController = CountDownController();
    this._predictService = PredictService.instance;
    this._type = this.widget.type;
    this._stop = true;
    this._loading = false;
    this._runnig = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._loadButtonConfiguration();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => this._usageInformationDialog(),
    );
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
    String assetName,
    String title,
    double width,
    bool isCollection,
  ) {
    return GestureDetector(
      onTap: () => this.startShooting(isCollection),
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

  _informativeDialog(String message, DialogType type) {
    this._dialogAdapter.show(
          context,
          type,
          'Informativo',
          message,
        );
  }

  _recordingTypeDialog() {
    this._dialogAdapter.show(
          context,
          DialogType.NO_HEADER,
          'Tipo de gravação',
          'A gravação frontal está em fase de coleta de imagem sem retornar a porcentagem de Parkinson',
          btnOk: this._buildWalkTypeCard('walkOne', 'Perfil', 50, false),
          btnCancel: this._buildWalkTypeCard('walkTwo', 'Frontal', 60, true),
        );
  }

  _usageInformationDialog() {
    if (this.widget.type == CameraType.VIDEO &&
        AppConfig.instance.usageGuidance) {
      this._dialogAdapter.show(
        context,
        DialogType.NO_HEADER,
        'Orientações de uso',
        null,
        closeIcon: Text(''),
        btnOkLabel: 'Continuar',
        onOk: () {
          if (!AppConfig.instance.usageGuidance) {
            this.addPrefs('usage_guidance', 'no');
          }
        },
        body: Column(
          children: [
            CameraUsageInformation(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomCheckbox(
                  activeColor: ThemeConfig.primaryColor,
                  checkColor: ThemeConfig.ternaryColor,
                  caption: 'Não mostrar novamente?',
                  height: 30,
                  remember: (status) => {
                    AppConfig.instance.usageGuidance = !status,
                  },
                )
              ],
            ),
          ],
        ),
      );
    }
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
          onPressed: () {
            if (this._type != null) {
              Navigator.pop(context);
              DashboardActions.instance.onRelocateInnerPage();
            } else {
              this._reset();
            }
          },
          visible: true,
        ),
        CameraButton(
          countDownController: this._countDownController,
          tooltip: this._cameraButtonTooltip,
          backgroundColor: this._cameraButtonBackground,
          icon: this._cameraButtonIcon,
          onPressed: this._cameraButtonOnPressed,
          companionLabel: this._cameraButtonLabel,
          onStart: this._cameraButtonOnStart,
          onComplete: this._cameraButtonOnComplete,
          isLoading: this._loading,
          visible: true,
        ),
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
      case CameraType.IMAGE:
        this._cameraButtonIcon = Icons.camera_alt;
        this._cameraButtonOnPressed = () => this.takePicture();
        this._cameraButtonTooltip = 'Capturar';
        break;
      case CameraType.VIDEO:
        this._cameraButtonIcon = Icons.videocam;
        this._cameraButtonOnPressed = this._recordingTypeDialog;
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
        this._cameraButtonOnPressed = () {
          Navigator.pop(context, this._image);
          DashboardActions.instance.onRelocateInnerPage();
        };
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
    var _path = AppConfig.instance.isAnEmulator
        ? await AssetConfig.instance.getTestImagePath()
        : file.path;

    this.setState(() {
      this._image = File(_path);
      this._type = null;
    });
    this._loadButtonConfiguration();
  }

  void startShooting(bool isCollection) async {
    try {
      if (!this._runnig) {
        // dismiss dialogs
        this._dialogAdapter.dismiss();

        // execution started
        this.setState(() => this._runnig = true);

        // create a run id
        String _authCode =
            await this._predictService.createPredictionAuthCode();

        // initializes the screen timer
        await this._countdown(3);
        await this._initializeControllerFuture;
        this._countDownController.start();
        this._capturedImagesCounter = 0;
        this._senderImagesCounter = 0;
        XFile _capture;

        while (!this._stop) {
          _capture = await this._controller.takePicture();

          if (AppConfig.instance.isAnEmulator) {
            _capture = new XFile(await AssetConfig.instance.getTestImagePath());
          }

          this
              ._predictService
              .addImageQueue(
                _authCode,
                this._capturedImagesCounter++,
                _capture,
                isCollection,
              )
              .whenComplete(() => this._senderImagesCounter++);
          await Future.delayed(Duration(seconds: 1));
        }

        if (isCollection) {
          this._informativeDialog(
            'Coleta efetuada com sucesso, muito obrigado pela ajuda!',
            DialogType.SUCCES,
          );
        } else {
          this.terminate(_authCode);
          this._informativeDialog(
            'Estamos analisando as imagens, em instantes receberá os resultados!',
            DialogType.INFO,
          );
        }
      }
    } catch (error) {
      this._reset();
      this._informativeDialog(
        'Ocorreu um erro, favor tentar novamente!',
        DialogType.ERROR,
      );
    }
  }

  Future _countdown(int timer) async {
    while (timer > 0) {
      this.setState(() => this._cameraButtonLabel = timer.toString());
      timer--;
      await Future.delayed(Duration(seconds: 1));
    }
  }

  Future terminate(code) async {
    do {
      await Future.delayed(Duration(seconds: 1));
    } while (this._runnig ||
        this._senderImagesCounter < this._capturedImagesCounter);

    this._predictService.requestTerminate(
          code,
          this.widget.patient.id,
        );
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
}
