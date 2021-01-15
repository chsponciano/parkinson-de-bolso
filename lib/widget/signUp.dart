import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/widget/customRaisedButton.dart';
import 'package:parkinson_de_bolso/widget/customScaffold.dart';
import 'package:parkinson_de_bolso/widget/customTextField.dart';
import 'package:parkinson_de_bolso/widget/customTitlePage.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                      title: titleSignUp,
                      color: ternaryColor,
                      distanceNextLine: 30.0,
                      addIcon: true,
                    ),
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
                    SizedBox(height: 15),
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
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

}