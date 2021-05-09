import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:parkinson_de_bolso/adapter/aws.adpater.dart';
import 'package:http/http.dart' as http;

class ConfigurationService {
  ConfigurationService._privateConstructor();
  static final ConfigurationService instance =
      ConfigurationService._privateConstructor();
  final AwsAdapter awsAdapter = AwsAdapter.instance;
  static final String path = '/api/configuration';

  Future<Map<String, String>> getGeneralSettings() async {
    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
          'GET',
          path,
        );

    final http.Response response = await http.get(
      signedRequest.url,
      headers: signedRequest.headers,
    );

    if (response.statusCode == 200) {
      List<Map<String, String>> data = jsonDecode(response.body);
      return data[0];
    } else {
      throw Exception('Failed to load patients');
    }
  }
}
