import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/utilities/route.dart';
import 'package:parkinson_de_bolso/widget/customScaffold.dart';
import 'package:parkinson_de_bolso/widget/customTextField.dart';
import 'package:parkinson_de_bolso/widget/customTitlePage.dart';
import 'package:parkinson_de_bolso/widget/customCheckbox.dart';
import 'package:parkinson_de_bolso/widget/customAnchorText.dart';
import 'package:parkinson_de_bolso/widget/customRaisedButton.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: defaultGradient
              ),
            ),
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 120.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomTitlePage(
                      title: titleSignIn,
                      color: ternaryColor,
                      distanceNextLine: 30.0,
                      addIcon: true,
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
                          onPressed: () => Navigator.pushNamed(context, redefinePasswordRoute)
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
                      onTap: () => Navigator.pushNamed(context, signUpRoute),
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}