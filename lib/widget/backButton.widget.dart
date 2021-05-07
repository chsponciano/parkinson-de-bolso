import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final double paddingValue;
  final VoidCallback onPressed;
  final bool visible;

  const BackButtonWidget({
    Key key,
    this.backgroundColor,
    this.paddingValue,
    this.onPressed,
    this.iconColor,
    this.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: this.visible,
      child: Padding(
        padding: EdgeInsets.all(this.paddingValue),
        child: CircleAvatar(
          radius: this.paddingValue,
          backgroundColor: this.backgroundColor,
          child: IconButton(
            tooltip: 'Voltar',
            icon: Icon(
              Icons.arrow_back,
              color: this.iconColor,
            ),
            onPressed: this.onPressed,
          ),
        ),
      ),
    );
  }
}
