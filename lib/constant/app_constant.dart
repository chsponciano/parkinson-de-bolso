import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/model/navegation_model.dart';

// titles
const applicationName = 'Parkinson de Bolso';
const caption = 'Acompanhe a evolução dos pacientes com apenas alguns cliques';
const titleSignIn = 'Acessar conta';
const titleSignUp = 'Criar conta';
const titleRedefinePassword = 'Redefinir senha';

//font
const defaultFont = 'OpenSans';

// color
const primaryColor = Color(0xFF1A237E);
const secondaryColor = Color(0xFF26C6DA);
const ternaryColor = Color(0xFFFFFFFF);
const dashboardBarColor = primaryColor;
const primaryColorDashboardBar = ternaryColor;
const secondaryColorDashboardBar = Color(0x8AFFFFFF);
const ternaryColorDashboardBar = primaryColor;
const floatingButtonDashboard = primaryColor;
const formBackgroundColor = Color(0xFFEEEEEE);
const formForegroundColor = Color(0xFF757575);
const alternativeColorTransparency = Color(0xFFFFFFFF);
const errorBoxColor = Color(0xFFB71C1C);

// gradient
const defaultGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    secondaryColor,
    primaryColor
  ],
);

// bottom navigation bar item
const allNavegation = <NavegationModel>[
  NavegationModel('Pacientes', Icons.people, NavegationType.PATIENT),
  NavegationModel('Relatórios', Icons.analytics, NavegationType.REPORT),
  NavegationModel('Configurações', Icons.settings, NavegationType.SETTING)
];