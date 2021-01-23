import 'package:flutter/material.dart';

class CustomValueTitle extends StatelessWidget {
  static final String _separator = ': '; 
  final double width;
  final String title;
  final String value;
  final double size;

  CustomValueTitle({this.width, this.title, this.value, this.size});

  Text _buildText(String text, bool isBold) {
    return Text(
      text,
      style: TextStyle(
        fontSize: this.size,
        fontWeight: isBold ? FontWeight.bold : null
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: this.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          this._buildText(title + _separator, true),
          this._buildText(value, false)
        ],
      ),
    );
  }

}