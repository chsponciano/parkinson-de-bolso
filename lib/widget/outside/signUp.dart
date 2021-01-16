import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/widget/customized/customized.dart';
import 'package:parkinson_de_bolso/widget/outside/outsideTheme.dart';
import 'package:parkinson_de_bolso/widget/own/own.dart';

class SignUp extends StatelessWidget {
  static const routeName = '/signUpRoute';

  @override
  Widget build(BuildContext context) {
    return OutsideTheme(
      children: [
        TitlePage(
          title: titleSignUp,
          color: ternaryColor,
          distanceNextLine: 30.0,
          addIcon: true,
        ),
        PbTextField(
          borderRadius: 10.0,
          color: ternaryColor,
          height: 60.0,
          title: 'Nome',
          hint: 'Digite seu nome',
          icon: Icons.people,
          padding: EdgeInsets.only(top: 14.0),
          type: TextInputType.name,
          distanceNextLine: 30.0,
        ),
        PbTextField(
          borderRadius: 10.0,
          color: ternaryColor,
          height: 60.0,
          title: 'E-mail',
          hint: 'Digite seu e-mail',
          icon: Icons.email,
          padding: EdgeInsets.only(top: 14.0),
          type: TextInputType.emailAddress,
          distanceNextLine: 30.0,
        ),
        PbTextField(
          borderRadius: 10.0,
          color: ternaryColor,
          height: 60.0,
          title: 'Senha',
          hint: 'Digite sua senha',
          icon: Icons.lock,
          padding: EdgeInsets.only(top: 14.0),
          distanceNextLine: 10.0,
        ),
        SizedBox(height: 15),
        PbRaisedButton(
          label: 'Criar conta',
          width: double.infinity,
          background: ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 25.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () => print('Login Button Pressed'),
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