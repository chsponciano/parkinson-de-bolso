import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/widget/footerButton.widget.dart';

class FooterGroupButtonWidget extends StatelessWidget {
  final List<FooterButtonWidget> buttons;

  FooterGroupButtonWidget({
    @required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buttons.toList(),
          ),
        ),
      ),
    );
  }
}
