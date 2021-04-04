import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:parkinson_de_bolso/config/asset_config.dart';
import 'package:parkinson_de_bolso/model/user_model.dart';
import 'package:parkinson_de_bolso/util/shared_preferences_util.dart';

class AppConfig with SharedPreferencesUtil {
  AppConfig._privateConstructor();
  static final AppConfig instance = AppConfig._privateConstructor();
  final AssetConfig assetConfig = AssetConfig.instance;

  bool firstAccess, usageGuidance;
  UserModel loggedInUser;
  CognitoUserSession session;
  String applicationName, caption;

  Future<void> initialize() async {
    await DotEnv.load(fileName: '.env');
    this.firstAccess = (await this.getPrefs('user_email')) == null;
    this.usageGuidance = (await this.getPrefs('usage_guidance')) == null;
    this.loggedInUser = null;
    this.session = null;
    this.applicationName = 'Parkinson de Bolso';
    this.caption =
        'Acompanhe a evolução dos pacientes com apenas alguns cliques';
  }
}
