import 'package:flutter/material.dart';
import 'custom_footer_button.dart';

// ignore: must_be_immutable
class CustomFooterGroupButton extends StatelessWidget {
  @required List<CustomFooterButton> buttons = const <CustomFooterButton>[];

  CustomFooterGroupButton({this.buttons}) : 
    assert(buttons != null);

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