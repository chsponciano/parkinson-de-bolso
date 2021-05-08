import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:parkinson_de_bolso/adapter/aws.adpater.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:http/http.dart' as http;

class SettingService {
  SettingService._privateConstructor();
  static final SettingService instance = SettingService._privateConstructor();
  final AwsAdapter awsAdapter = AwsAdapter.instance;
  static final String path = '/api/privacy';

  Future<void> cleanData() async {
    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
          'DELETE',
          '$path/clean/${AppConfig.instance.loggedInUser.id}',
        );
    await http.delete(
      signedRequest.url,
      headers: signedRequest.headers,
    );
  }

  Future<void> deleteUser() async {
    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
          'DELETE',
          '$path/delete/user/${AppConfig.instance.loggedInUser.id}',
        );
    await http.delete(
      signedRequest.url,
      headers: signedRequest.headers,
    );
  }
}
