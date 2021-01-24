import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/route.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/modules/auth/auth_module.dart';
import 'package:parkinson_de_bolso/modules/auth/change_password/redefine_password.dart';
import 'package:parkinson_de_bolso/modules/auth/sign_up/sign_up.dart';
import 'package:parkinson_de_bolso/modules/dashboard/dashboard_module.dart';
import 'package:parkinson_de_bolso/widget/custom_anchor_text.dart';
import 'package:parkinson_de_bolso/widget/custom_checkbox.dart';
import 'package:parkinson_de_bolso/widget/custom_raised_button.dart';
import 'package:parkinson_de_bolso/widget/custom_text_field.dart';

// ignore: must_be_immutable
class SignIn extends StatelessWidget {
  static const String routeName = '/signInRoute';

  @override
  Widget build(BuildContext context) {
    return AuthModule(
      widgetTitle: titleSignIn,
      children: [
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomCheckbox(
              activeColor: ternaryColor,
              checkColor: primaryColor,
              caption: 'Lembrar',
              height: 20.0,
            ),
            CustomAnchorText(
              alignment: Alignment.centerRight,
              caption: 'Esqueceu a senha?',
              color: ternaryColor,
              onPressed: () => Navigator.pushNamed(context, RedefinePassword.routeName)
            )
          ],
        ),
        SizedBox(height: 15),
        CustomRaisedButton(
          label: 'Acessar',
          width: double.infinity,
          background: ternaryColor,
          padding: EdgeInsets.symmetric(vertical: 25.0),
          paddingInternal: EdgeInsets.all(15.0),
          onPressed: () => {
            RouteHandler.loggedIn = true,
            RouteHandler.token = 'aaaaaaaa',
            Navigator.pushNamed(context, DashboardModule.routeName)
          },
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
