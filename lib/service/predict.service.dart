import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/adapter/aws.adpater.dart';

class PredictService {
  PredictService._privateConstructor();
  static final PredictService instance = PredictService._privateConstructor();
  final AwsAdapter awsAdapter = AwsAdapter.instance;
  static final String path = '/api/predict';

  Future<String> getId() async {
    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
      'POST',
      path + '/initialize',
      body: {},
    );

    final http.Response response = await http.post(
      signedRequest.url,
      headers: signedRequest.headers,
      body: signedRequest.body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['predictid'];
    } else {
      throw Exception('Failure to acquire authorization for prediction');
    }
  }

  Future<Map> evaluator(String predictId, String patientId, int index,
      XFile image, bool isCollection) async {
    try {
      final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
        'POST',
        path,
        body: {
          'predictid': predictId,
          'patientid': patientId,
          'index': index,
          'isCollection': isCollection,
          'image': {
            'data': base64Encode(await image.readAsBytes()),
            'filename': image.path.split('/').last
          }
        },
      );

      final http.Response response = await http.post(
        signedRequest.url,
        headers: signedRequest.headers,
        body: signedRequest.body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to evaluator predict');
      }
    } catch (error) {
      return null;
    }
  }

  Future<Map> conclude(String predictId) async {
    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
      'POST',
      path + '/conclude',
      body: {'predictid': predictId},
    );

    final http.Response response = await http.post(
      signedRequest.url,
      headers: signedRequest.headers,
      body: signedRequest.body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to conclude predict');
    }
  }
}
