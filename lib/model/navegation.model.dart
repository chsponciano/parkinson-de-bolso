import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/type/navegation.type.dart';

class NavegationModel {
  final String title;
  final IconData icon;
  final NavegationType type;
  const NavegationModel(this.title, this.icon, this.type);
}
