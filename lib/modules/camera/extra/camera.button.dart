import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';

class CameraButton extends StatefulWidget {
  final CountDownController countDownController;
  final String tooltip;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback onStart;
  final VoidCallback onComplete;
  final String companionLabel;
  final bool isLoading;
  final bool visible;

  const CameraButton(
      {Key key,
      @required this.countDownController,
      this.tooltip,
      this.backgroundColor,
      this.icon,
      this.onPressed,
      this.companionLabel,
      this.onStart,
      this.onComplete,
      this.isLoading = false,
      @required this.visible})
      : super(key: key);

  @override
  _CameraButtonState createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> {
  bool _runnig;

  @override
  void initState() {
    this._runnig = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _size = MediaQuery.of(context).size.width / 6;

    return Visibility(
      visible: this.widget.visible,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                alignment: FractionalOffset.center,
                children: [
                  CircularCountDownTimer(
                    duration: int.parse(env['MAX_PHOTO_SEQUENCE']),
                    controller: this.widget.countDownController,
                    width: _size,
                    height: _size,
                    color: Colors.grey[300],
                    fillColor:
                        (this._runnig) ? Colors.red[900] : Colors.grey[300],
                    backgroundColor: (this.widget.backgroundColor != null)
                        ? this.widget.backgroundColor
                        : ThemeConfig.primaryColor,
                    strokeWidth: 5.0,
                    strokeCap: StrokeCap.round,
                    isReverse: false,
                    isReverseAnimation: false,
                    isTimerTextShown: false,
                    autoStart: false,
                    onStart: () {
                      this.setState(() => this._runnig = true);
                      if (this.widget.onStart != null)
                        this.widget.onStart.call();
                    },
                    onComplete: () {
                      this.setState(() => this._runnig = false);
                      if (this.widget.onComplete != null)
                        this.widget.onComplete.call();
                    },
                  ),
                  IconButton(
                      tooltip: this.widget.tooltip,
                      icon: (this.widget.isLoading)
                          ? CircularProgressIndicator(
                              strokeWidth: 3.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  ThemeConfig.ternaryColor),
                            )
                          : (this.widget.companionLabel == null)
                              ? Icon(
                                  this.widget.icon,
                                  color: ThemeConfig.ternaryColor,
                                  size: 30,
                                )
                              : Text(
                                  this.widget.companionLabel,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: ThemeConfig.ternaryColor,
                                  ),
                                ),
                      onPressed: this.widget.onPressed),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
