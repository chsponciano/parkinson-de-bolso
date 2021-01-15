import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/utilities/constants.dart';
import 'package:parkinson_de_bolso/utilities/route.dart';
import 'package:parkinson_de_bolso/widget/customRaisedButton.dart';
import 'package:parkinson_de_bolso/widget/customScaffold.dart';
import 'package:parkinson_de_bolso/widget/customTextField.dart';
import 'package:parkinson_de_bolso/widget/customTitlePage.dart';

class RedefinePassword extends StatefulWidget {
  @override
  RedefinePasswordState createState() => RedefinePasswordState();
}

class RedefinePasswordState extends State<RedefinePassword> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
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
                  children: [
                    CustomTitlePage(
                      title: titleRedefinePassword,
                      color: ternaryColor,
                      distanceNextLine: 30.0,
                      addIcon: true,
                    ),
                    Text(
                      'Esqueceu a senha? Preecha o campo abaixo para reiniciar a senha.',
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
                      hint: 'Digite um e-mail já cadastrado',
                      icon: Icons.email,
                      padding: EdgeInsets.only(top: 14.0),
                      type: TextInputType.emailAddress,
                      distanceNextLine: 10.0,
                    ),
                    CustomRaisedButton(
                      label: 'Redefinir senha',
                      width: double.infinity,
                      background: ternaryColor,
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      paddingInternal: EdgeInsets.all(15.0),
                      onPressed: () => Navigator.pushNamed(context, confirmPasswordResetRoute),
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
      ),
    );
  }

}