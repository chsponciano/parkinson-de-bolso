import 'package:flutter/material.dart';

class ThemeConfig {
  static String get defaultFont => 'OpenSans';
  static Color get primaryColor => Color(0xFF1A237E);
  static Color get secondaryColor => Color(0xFF26C6DA);
  static Color get ternaryColor => Color(0xFFFFFFFF);
  static Color get dashboardBarColor => primaryColor;
  static Color get primaryColorDashboardBar => ternaryColor;
  static Color get secondaryColorDashboardBar => Color(0x8AFFFFFF);
  static Color get ternaryColorDashboardBar => primaryColor;
  static Color get floatingButtonDashboard => primaryColor;
  static Color get formBackgroundColor => Color(0xFFEEEEEE);
  static Color get formForegroundColor => Color(0xFF757575);
  static Color get alternativeColorTransparency => Color(0xFFFFFFFF);
  static Color get errorBoxColor => Color(0xFFB71C1C);
  static LinearGradient get defaultGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [secondaryColor, primaryColor],
      );
}
