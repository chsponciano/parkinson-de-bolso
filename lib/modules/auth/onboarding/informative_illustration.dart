import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app_config.dart';
import 'package:parkinson_de_bolso/config/theme_config.dart';

class InformativeIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 50, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AppConfig.instance.assetConfig.get('onboarding'),
            height: 400.0,
          ),
          Text(
            AppConfig.instance.applicationName,
            style: TextStyle(
                color: ThemeConfig.ternaryColor,
                fontSize: 30.0,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.0),
          ),
          SizedBox(height: 10.0),
          Text(
            AppConfig.instance.caption,
            style: TextStyle(
                color: ThemeConfig.ternaryColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.0),
          )
        ],
      ),
    );
  }
}
