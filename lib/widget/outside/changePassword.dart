import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/widget/customized/customized.dart';
import 'package:parkinson_de_bolso/widget/outside/outsideTheme.dart';
import 'package:parkinson_de_bolso/widget/own/TitlePage.dart';

class ChangePassword extends StatelessWidget {
  static const routeName = '/changePasswordRoute';

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
          'Digite sua nova senha!',
          style: TextStyle(
            color: ternaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 20),
        PbTextField(
          borderRadius: 10.0,
          color: ternaryColor,
          height: 60.0,
          title: 'Nova senha',
          hint: 'Digite sua nova senha',
          icon: Icons.lock,
          padding: EdgeInsets.only(top: 14.0),
          distanceNextLine: 30.0,
        ),
        PbTextField(
          borderRadius: 10.0,
          color: ternaryColor,
          height: 60.0,
          title: 'Confirme a senha',
          hint: 'Confirme sua nova senha',
          icon: Icons.lock,
          padding: EdgeInsets.only(top: 14.0),
          distanceNextLine: 10.0,
        ),
        PbRaisedButton(
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