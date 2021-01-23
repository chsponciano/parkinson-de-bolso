import 'package:flutter/material.dart';
import 'custom_outline_button.dart';

class CustomFooterButton extends StatelessWidget {
  final String label;
  final Color background;
  final VoidCallback onPressed;

  CustomFooterButton({@required this.label, @required this.background, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomOutlineButton(
        background: this.background,
        textColor: this.background,
        label: this.label,
        onPressed: this.onPressed,
        padding: EdgeInsets.all(10)
      ),
    );
  }
}

