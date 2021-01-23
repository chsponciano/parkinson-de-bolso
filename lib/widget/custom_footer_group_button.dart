import 'package:flutter/material.dart';
import 'custom_footer_button.dart';

class CustomFooterGroupButton extends StatelessWidget {
  final List<CustomFooterButton> buttons;

  CustomFooterGroupButton({@required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buttons.toList()
          ),
        ),
      ),
    );
  }
}