import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.signIn.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/auth.signUp.page.dart';
import 'package:parkinson_de_bolso/modules/auth/pages/extra/auth.informative.dart';
import 'package:parkinson_de_bolso/widget/custom_footer_button.dart';
import 'package:parkinson_de_bolso/widget/custom_footer_group_button.dart';
import 'package:parkinson_de_bolso/widget/custom_scaffold.dart';

class OnboardingPage extends StatefulWidget {
  static const String routeName = '/';

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: ThemeConfig.defaultGradient),
        child: Column(
          children: <Widget>[
            AuthInformative(),
            CustomFooterGroupButton(
              buttons: [
                CustomFooterButton(
                  background: ThemeConfig.ternaryColor,
                  label: 'Acessar conta',
                  onPressed: () =>
                      Navigator.pushNamed(context, SignInPage.routeName),
                ),
                CustomFooterButton(
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
