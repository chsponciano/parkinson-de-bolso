import 'package:flutter/material.dart';

enum NavegationType {
  PATIENT,
  REPORT,
  SETTING    
}

class NavegationModel {
  final String title;
  final IconData icon;
  final NavegationType type;
  const NavegationModel(this.title, this.icon, this.type);
}