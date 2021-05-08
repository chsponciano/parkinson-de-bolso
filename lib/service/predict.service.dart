import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/adapter/aws.adpater.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/model/execution.model.dart';

class PredictService {
  PredictService._privateConstructor();
  static final PredictService instance = PredictService._privateConstructor();
  final AwsAdapter awsAdapter = AwsAdapter.instance;
  static final String path = '/api/predict';

  Future<String> createPredictionAuthCode() async {
    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
      'POST',
      '$path/create/id',
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

  Future<Map> addImageQueue(
    String predictId,
    int index,
    XFile image,
    bool isCollection,
  ) async {
    try {
      final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
        'POST',
        '$path/add/image',
        body: {
          'predictid': predictId,
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
        throw Exception('Failed to add image prediction queue');
      }
    } catch (error) {
      return null;
    }
  }

  Future<bool> requestTerminate(String predictId, String patientId) async {
    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
      'POST',
      '$path/request/terminate',
      body: {
        'predictid': predictId,
        'patientid': patientId,
        'userid': AppConfig.instance.loggedInUser.id,
      },
    );

    final http.Response response = await http.post(
      signedRequest.url,
      headers: signedRequest.headers,
      body: signedRequest.body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to request terminate predict');
    }
  }

  Future<List<ExecutionModel>> getAll(String predictId) async {
    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
          'GET',
          path,
        );

    final http.Response response = await http.get(
      '${signedRequest.url}/$predictId',
      headers: signedRequest.headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => ExecutionModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load executation classification');
    }
  }
}
