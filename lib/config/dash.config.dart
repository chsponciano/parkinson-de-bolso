import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/type/module.type.dart';
import 'package:parkinson_de_bolso/util/sharedPreferences.util.dart';

class DashConfig with SharedPreferencesUtil {
  DashConfig._privateConstructor();
  static final DashConfig instance = DashConfig._privateConstructor();
  AppConfig _appConfig = AppConfig.instance;
  Function _toAssignBarAttributesFunction;
  BuildContext _context;

  setContext(BuildContext context) {
    this._context = context;
  }

  getContext() {
    return this._context;
  }

  setFunctionToAssignBarAttributes(Function f) {
    this._toAssignBarAttributesFunction = f;
  }

  setBarAttributes(Widget leading, Widget title, List<Widget> actions) {
    this._toAssignBarAttributesFunction(leading, title, actions);
  }

  logout() {
    this.removePrefs('user_email');
    this.removePrefs('user_password');
    this.removePrefs('usage_guidance');
    this._appConfig.loggedInUser = null;
    this._appConfig.session = null;
    this._appConfig.usageGuidance = null;
    this._appConfig.changeModule(ModuleType.AUTH);
  }
}
