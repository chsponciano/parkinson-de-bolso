import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';

class DialogAdapter {
  DialogAdapter._privateConstructor();
  static final DialogAdapter instance = DialogAdapter._privateConstructor();

  show(
    BuildContext context,
    DialogType type,
    String title,
    String message, {
    Function onClose,
    Function onOk,
    Widget btnOk,
    Widget btnCancel,
    String btnOkLabel,
    Widget closeIcon,
    Widget body,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      buttonsBorderRadius: BorderRadius.all(
        Radius.circular(2),
      ),
      headerAnimationLoop: false,
      title: title,
      desc: message,
      showCloseIcon: true,
      btnCancelOnPress: onClose,
      btnOkOnPress: onOk,
      btnOkColor: ThemeConfig.primaryColor,
      btnOkText: btnOkLabel,
      body: body,
      closeIcon: closeIcon,
      btnOk: btnOk,
      btnCancel: btnCancel,
    ).show();
  }
}
