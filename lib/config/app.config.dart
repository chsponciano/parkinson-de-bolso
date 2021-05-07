import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:parkinson_de_bolso/config/asset.config.dart';
import 'package:parkinson_de_bolso/model/user.model.dart';
import 'package:parkinson_de_bolso/type/module.type.dart';
import 'package:parkinson_de_bolso/util/sharedPreferences.util.dart';

class AppConfig with SharedPreferencesUtil {
  AppConfig._privateConstructor();
  static final AppConfig instance = AppConfig._privateConstructor();
  final AssetConfig assetConfig = AssetConfig.instance;

  bool firstAccess, usageGuidance;
  UserModel loggedInUser;
  CognitoUserSession session;
  String applicationName, caption;
  ModuleType moduleType;
  IconButton leading;
  bool isAnEmulator;
  Function _changeModuleFunction;

  Future<void> initialize() async {
    await DotEnv.load(fileName: '.env');
    this.firstAccess = (await this.getPrefs('user_email')) == null;
    this.usageGuidance = (await this.getPrefs('usage_guidance')) == null;
    this.loggedInUser = null;
    this.session = null;
    this.applicationName = DotEnv.env['APPLICATION_NAME'];
    this.caption = DotEnv.env['APPLICATION_CAPTION'];
  }

  setChangeModuleFunction(Function f) {
    this._changeModuleFunction = f;
  }

  changeModule(ModuleType type) {
    this._changeModuleFunction(type);
  }
}
