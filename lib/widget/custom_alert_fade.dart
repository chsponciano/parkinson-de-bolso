import 'package:flutter/material.dart';

class CustomAlertFade extends StatefulWidget {
  final AnimationController controller;
  final String message;
  final Color backgroud;
  final Color textColor;

  const CustomAlertFade({Key key, this.controller, this.message, this.backgroud, this.textColor}) : super(key: key);

  @override
  _CustomAlertFadeState createState() => _CustomAlertFadeState();
}

class _CustomAlertFadeState extends State<CustomAlertFade> {
  AnimationController _controller;
  Animation<double> _transition;

  @override
  void initState() {
    super.initState();
    this._controller = this.widget.controller;
    this._controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(seconds: 5));
        this._controller.reverse();
      }
    });
    this._transition = Tween<double>(begin: 0.0, end: 1.0).animate(this._controller);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition (
        opacity: _transition,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (this.widget.backgroud != null) ? this.widget.backgroud : Colors.red[900]
          ),
          padding: EdgeInsets.all(10),
          child: Text(
            (this.widget.message != null) ? this.widget.message : 'Ocorreu um erro, tentar novamente!',
            style: TextStyle(
              color: (this.widget.textColor != null) ? this.widget.textColor : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          )
        ),
      ),
    );
  }
}