import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:parkinson_de_bolso/config/asset.config.dart';
import 'package:parkinson_de_bolso/model/appBarButton.model.dart';
import 'package:parkinson_de_bolso/model/user.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/action/dashboard.actions.dart';
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
  Function _changeModuleFunction;
  ModuleType moduleType;
  Widget appBarTitle;
  List<AppBarButtonModel> actions;
  IconButton leading;
  bool isAnEmulator;

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

  changeModule(
    ModuleType type,
    Widget appBarTitle,
    List<AppBarButtonModel> actions,
    IconButton leading, {
    bool cache = false,
  }) {
    this.moduleType = type;
    if (type == ModuleType.DASHBOARD) {
      DashboardActions.instance.reset();
    }
    if (cache) {
      this._changeModuleFunction(
        type,
        this.appBarTitle,
        this.actions,
        this.leading,
      );
    } else {
      if (type != ModuleType.NOTIFICATION && type != ModuleType.CAMERA) {
        this.appBarTitle = appBarTitle;
        this.actions = actions;
        this.leading = leading;
      }
      this._changeModuleFunction(
        type,
        appBarTitle,
        actions,
        leading,
      );
    }
  }
}
