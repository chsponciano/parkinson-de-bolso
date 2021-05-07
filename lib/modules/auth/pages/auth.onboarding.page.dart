import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.signIn.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.signUp.page.dart';
import 'package:parkinson_de_bolso/modules/auth/extra/auth.informative.dart';
import 'package:parkinson_de_bolso/widget/footerButton.widget.dart';
import 'package:parkinson_de_bolso/widget/footerGroupButton.widget.dart';
import 'package:parkinson_de_bolso/widget/scaffold.widget.dart';

class OnboardingPage extends StatefulWidget {
  static const String routeName = '/';

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: ThemeConfig.defaultGradient),
        child: Column(
          children: <Widget>[
            AuthInformative(),
            FooterGroupButtonWidget(
              buttons: [
                FooterButtonWidget(
                  background: ThemeConfig.ternaryColor,
                  label: 'Acessar conta',
                  onPressed: () =>
                      Navigator.pushNamed(context, SignInPage.routeName),
                ),
                FooterButtonWidget(
                  background: ThemeConfig.ternaryColor,
                  label: 'Criar conta',
                  onPressed: () =>
                      Navigator.pushNamed(context, SignUpPage.routeName),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
