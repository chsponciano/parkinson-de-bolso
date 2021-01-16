import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/modules/auth/auth_module.dart';
import 'package:parkinson_de_bolso/modules/auth/change_password/change_password.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_field.dart';

// ignore: must_be_immutable
class VerificationCode extends StatelessWidget {
  static const String routeName = '/verificationCodeRoute';

  @override
  Widget build(BuildContext context) {
    return AuthModule(
      widgetTitle: titleRedefinePassword,
      children: [
        Text(
          'Digite o código enviado em seu e-mail.',
          style: TextStyle(
            color: ternaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 10),
        CustomTextField(
          borderRadius: 10.0,
          color: ternaryColor,
          height: 60.0,
          hint: 'Digite o código',
          icon: Icons.confirmation_number,
          padding: EdgeInsets.only(top: 14.0),
          type: TextInputType.number,
          distanceNextLine: 10.0,
        ),
        CustomRaisedButton(
          label: 'Confirmar reinicio',
          width: double.infinity,
          background: ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 25.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () => Navigator.pushNamed(context, ChangePassword.routeName),
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