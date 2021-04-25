import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/route/auth.route.dart';

class AuthMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.instance.applicationName,
      theme: ThemeData(
        fontFamily: ThemeConfig.defaultFont,
        primaryColor: ThemeConfig.primaryColor,
        appBarTheme: AppBarTheme(
          color: ThemeConfig.primaryColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: authRoutes(),
      // home: AppConfig.instance.firstAccess ? Onboarding() : SignIn(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
    );
  }
}
