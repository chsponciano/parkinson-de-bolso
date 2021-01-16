import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/widget/customized/customized.dart';
import 'package:parkinson_de_bolso/widget/outside/changePassword.dart';
import 'package:parkinson_de_bolso/widget/outside/outsideTheme.dart';
import 'package:parkinson_de_bolso/widget/own/own.dart';

class VerificationCode extends StatelessWidget {
  static const routeName = '/verificationCodeRoute';

  @override
  Widget build(BuildContext context) {
    return OutsideTheme(
      children: [
        TitlePage(
          title: titleRedefinePassword,
          color: ternaryColor,
          distanceNextLine: 30.0,
          addIcon: true,
        ),
        Text(
          'Digite o código enviado em seu e-mail.',
          style: TextStyle(
            color: ternaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 10),
        PbTextField(
          borderRadius: 10.0,
          color: ternaryColor,
          height: 60.0,
          hint: 'Digite o código',
          icon: Icons.confirmation_number,
          padding: EdgeInsets.only(top: 14.0),
          type: TextInputType.number,
          distanceNextLine: 10.0,
        ),
        PbRaisedButton(
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