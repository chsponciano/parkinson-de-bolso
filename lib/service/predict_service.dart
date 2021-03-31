import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/model/execution_classification_model.dart';
import 'package:parkinson_de_bolso/service/aws_cognito_service.dart';

class PredictService {
  PredictService._privateConstructor();
  static final PredictService instance = PredictService._privateConstructor();
  final AwsCognitoService awsCognitoService = AwsCognitoService.instance;
  static final String path = '/api/predict';

  Future<ExecutionClassificationModel> evaluator(
      String patientId, int index, XFile image) async {
    try {
      final SigV4Request signedRequest =
          this.awsCognitoService.getSigV4Request('POST', path, body: {
        'patientid': patientId,
        'index': index,
        'image': {
          'data': base64Encode(await image.readAsBytes()),
          'filename': image.path.split('/').last
        }
      });
      final http.Response response = await http.post(signedRequest.url,
          headers: signedRequest.headers, body: signedRequest.body);

      if (response.statusCode == 200) {
        return ExecutionClassificationModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to evaluator predict');
      }
    } catch (error) {
      return null;
    }
  }

  Future<Map> conclude(String patientId) async {
    final SigV4Request signedRequest =
        this.awsCognitoService.getSigV4Request('DELETE', path);
    final http.Response response = await http.delete(
        '${signedRequest.url}/$patientId',
        headers: signedRequest.headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to conclude predict');
    }
  }
}
