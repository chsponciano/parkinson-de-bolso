import 'package:flutter/material.dart';

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
const floatingButtonDashboard = primaryColor;

// gradient
const defaultGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    secondaryColor,
    primaryColor
  ],
);

// navegation item
const navegationLabelItem = ['Pacientes', 'Relatórios', 'Configurações'];
const navegationIconItem = [Icons.people, Icons.analytics, Icons.settings];