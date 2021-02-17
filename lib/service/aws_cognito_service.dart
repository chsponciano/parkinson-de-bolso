
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/model/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AwsCognitoService {
  AwsCognitoService._privateConstructor();
  static final AwsCognitoService instance = AwsCognitoService._privateConstructor();
  final CognitoUserPool _userPool = CognitoUserPool(env['AWS_USER_POOL_ID'], env['AWS_CLIENT_ID']);

  SigV4Request getSigV4Request(String method, String path, {Map queryParams, Map body}) {
    final CognitoCredentials credentials = CognitoCredentials(env['AWS_IDENTITY_POOL_ID'], this._userPool);
    final AwsSigV4Client awsSigV4Client = AwsSigV4Client(credentials.accessKeyId, credentials.secretAccessKey, env['AWS_HOST']);
    
    return SigV4Request(
      awsSigV4Client, 
      method: method, 
      path: path, 
      authorizationHeader: RouteHandler.session.getIdToken().getJwtToken(),
      queryParams: queryParams,
      body: body
    );
  }

  Future signUp(UserModel user) async {
    try {
      final userAttributes = [
        AttributeArg(name: 'name', value: user.name)
      ];

      await this._userPool.signUp(user.email, user.password, userAttributes: userAttributes);
    } on CognitoClientException catch (e) {
      if (e.code == 'UsernameExistsException') {
        throw 'E-mail já cadastrado';
      }
    }
  }

  Future signIn(String email, String password) async {
    final cognitoUser = new CognitoUser(email, this._userPool);
    final authDetails = new AuthenticationDetails(
      username: email,
      password: password,
    );

    CognitoUserSession session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);
    } on CognitoClientException catch (_) {
      throw 'E-mail e/ou senha incorreta';
    }
    
    Map<String, String> attributes = await this.getAttributes(cognitoUser);
    RouteHandler.loggedInUser = UserModel(
      email: email, 
      password: password, 
      name: attributes['name'],
      id: attributes['id']
    );

    RouteHandler.session = session;
  }

  Future<void> forgotPassword(String email) async {
    final cognitoUser = new CognitoUser(email, this._userPool);
    await cognitoUser.forgotPassword();
  }

  Future<bool> changePassword(String email, String code, String newPassword) async {
    final cognitoUser = new CognitoUser(email, this._userPool);
    return await cognitoUser.confirmPassword(code, newPassword);
  }

  Future<bool> deleteUser() async {
    final cognitoUser = new CognitoUser(RouteHandler.loggedInUser.email, this._userPool);
    return await cognitoUser.deleteUser();
  }

  Future<Map<String, String>> getAttributes(CognitoUser cognitoUser) async {
    final Map<String, String> attributes = Map();

    (await cognitoUser.getUserAttributes()).forEach((CognitoUserAttribute userAttributes) {
      if (userAttributes.name == 'sub') {
        attributes['id'] = userAttributes.value;
      }

      if (userAttributes.name == 'name') {
        attributes['name'] = userAttributes.value;
      }
    });

    return attributes;
  }
}