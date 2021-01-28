import 'package:flutter/material.dart';

enum SnackbarType {
  ERROR,
  WARNING,
  SUCESS
}
mixin SnackbarUtil {
  void showSnackbar(GlobalKey<ScaffoldState> key, String message, SnackbarType type) {
    Color color;
    switch (type) {
      case SnackbarType.ERROR:
        color = Colors.red[900];
        break;
      case SnackbarType.WARNING:
        color = Colors.amber;
        break;
      case SnackbarType.SUCESS:
        color = Colors.green[900];
        break;
      default:
        color = Colors.red[900];
    }

    key.currentState.showSnackBar(
      SnackBar(
        backgroundColor: color, 
        content: Text(message)
        )
      );
  }
}