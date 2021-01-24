import 'package:flutter/material.dart';

class CustomValueTitle extends StatelessWidget {
  static final String _separator = ': '; 
  final double width;
  final String title;
  final String value;
  final double size;
  final Color color;

  CustomValueTitle({this.width, this.title, this.value, this.size, this.color});

  Text _buildText(String text, bool isBold) {
    return Text(
      text,
      style: TextStyle(
        fontSize: this.size,
        fontWeight: isBold ? FontWeight.bold : null,
        color: this.color
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