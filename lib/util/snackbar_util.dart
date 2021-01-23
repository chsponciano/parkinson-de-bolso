import 'package:flutter/material.dart';

mixin SnackbarUtil {
  void showSnackbar(GlobalKey<ScaffoldState> key, String message, Color color) {
    key.currentState.showSnackBar(
      SnackBar(
        backgroundColor: color, 
        content: Text(message)
        )
      );
  }
}