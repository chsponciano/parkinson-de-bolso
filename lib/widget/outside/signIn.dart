import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/widget/customized/customized.dart';
import 'package:parkinson_de_bolso/widget/outside/outsideTheme.dart';
import 'package:parkinson_de_bolso/widget/outside/redefinePassword.dart';
import 'package:parkinson_de_bolso/widget/outside/signUp.dart';
import 'package:parkinson_de_bolso/widget/own/own.dart';

// ignore: must_be_immutable
class SignIn extends StatelessWidget {
  static const routeName = '/signInRoute';
  Function loginAction;

  SignIn({this.loginAction}):
    assert(loginAction != null);

  @override
  Widget build(BuildContext context) {
    return OutsideTheme(
      children: [
        TitlePage(
          title: titleSignIn,
          color: ternaryColor,
          distanceNextLine: 30.0,
          addIcon: true,
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PbCheckbox(
              activeColor: ternaryColor,
              checkColor: primaryColor,
              caption: 'Lembrar',
              height: 20.0,
            ),
            AnchorText(
              alignment: Alignment.centerRight,
              caption: 'Esqueceu a senha?',
              color: ternaryColor,
              onPressed: () => Navigator.pushNamed(context, RedefinePassword.routeName)
            )
          ],
        ),
        SizedBox(height: 15),
        PbRaisedButton(
          label: 'Acessar',
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
        SizedBox(height: 15),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUp.routeName),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Ainda não tem uma conta? ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Clique aqui!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class SignInArguments {
  final Function loginAction;
  SignInArguments({this.loginAction}):
    assert(loginAction != null);
}