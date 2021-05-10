import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class ConfigurationService {
  ConfigurationService._privateConstructor();
  static final ConfigurationService instance =
      ConfigurationService._privateConstructor();

  static final String path = '/api/configuration';

  Future<Map> getGeneralSettings() async {
    final http.Response response = await http.get(
      DotEnv.env['AWS_HOST'] + path,
    );
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      return json[0];
    } else {
      throw Exception('Failed to load configuration');
    }
  }
}
