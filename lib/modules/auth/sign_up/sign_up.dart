import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/modules/auth/auth_module.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_field.dart';

// ignore: must_be_immutable
class SignUp extends StatelessWidget {
  static const String routeName = '/signUpRoute';

  @override
  Widget build(BuildContext context) {
    return AuthModule(
      widgetTitle: titleSignUp,
      activateBackButton: true,
      children: [
        CustomTextField(
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
        CustomTextField(
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
        CustomTextField(
          borderRadius: 10.0,
          color: ternaryColor,
          height: 60.0,
          title: 'Senha',
          hint: 'Digite sua senha',
          icon: Icons.lock,
          padding: EdgeInsets.only(top: 14.0),
          distanceNextLine: 10.0,
        ),
        CustomRaisedButton(
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