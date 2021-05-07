import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/widget/outlineButton.widget.dart';

class FooterButtonWidget extends StatelessWidget {
  final String label;
  final Color background;
  final VoidCallback onPressed;

  FooterButtonWidget({
    @required this.label,
    @required this.background,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlineButtonWidget(
        background: this.background,
        textColor: this.background,
        label: this.label,
        onPressed: this.onPressed,
        padding: EdgeInsets.all(10),
      ),
    );
  }
}
