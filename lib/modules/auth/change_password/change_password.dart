import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/modules/auth/auth_module.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_field.dart';

// ignore: must_be_immutable
class ChangePassword extends StatelessWidget {
  static const String routeName = '/changePasswordRoute';

  @override
  Widget build(BuildContext context) {
    return AuthModule(
      widgetTitle: titleRedefinePassword,
      activateBackButton: true,
      children: [
        Text(
          'Digite sua nova senha!',
          style: TextStyle(
            color: ternaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 20),
        CustomTextField(
          borderRadius: 10.0,
          color: ternaryColor,
          height: 60.0,
          title: 'Nova senha',
          hint: 'Digite sua nova senha',
          icon: Icons.lock,
          padding: EdgeInsets.only(top: 14.0),
          distanceNextLine: 30.0,
        ),
        CustomTextField(
          borderRadius: 10.0,
          color: ternaryColor,
          height: 60.0,
          title: 'Confirme a senha',
          hint: 'Confirme sua nova senha',
          icon: Icons.lock,
          padding: EdgeInsets.only(top: 14.0),
          distanceNextLine: 10.0,
        ),
        CustomRaisedButton(
          label: 'Redefinir senha',
          width: double.infinity,
          background: ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 25.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () => print('Change password'),
          textColor: primaryColor,
          elevation: 5.0,
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}