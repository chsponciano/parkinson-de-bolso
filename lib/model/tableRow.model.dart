import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';

class TableRowModel {
  final List<String> values;
  final EdgeInsets padding;
  final bool isTitle;

  TableRowModel({
    @required this.padding,
    @required this.values,
    this.isTitle = false,
  });

  TableRow create() {
    return TableRow(
      decoration: this.isTitle
          ? BoxDecoration(
              color: ThemeConfig.primaryColor,
            )
          : null,
      children: this
          .values
          .map(
            (e) => Container(
              padding: this.padding,
              child: this.isTitle
                  ? Center(
                      child: Text(
                        e,
                        style: TextStyle(
                          color: ThemeConfig.ternaryColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : Text(e),
            ),
          )
          .toList(),
    );
  }
}
