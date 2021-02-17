import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/model/patient_classification_model.dart';
import 'package:parkinson_de_bolso/service/aws_cognito_service.dart';

class PatientClassificationService {
  PatientClassificationService._privateConstructor();
  static final PatientClassificationService instance = PatientClassificationService._privateConstructor();
  final AwsCognitoService awsCognitoService = AwsCognitoService.instance;
  static final String path = '/api/patient_classification';

  Future<List<PatientClassificationModel>> getAll(String patientId) async {
    final SigV4Request signedRequest = this.awsCognitoService.getSigV4Request('GET', path);
    final http.Response response = await http.get('${signedRequest.url}/patientid/$patientId', headers: signedRequest.headers);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => PatientClassificationModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load patient classification');
    }
  }

  Future<void> delete(String id) async {
    final SigV4Request signedRequest = this.awsCognitoService.getSigV4Request('DELETE', path);
    final http.Response response = await http.delete('${signedRequest.url}/$id', headers: signedRequest.headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete patient classification');
    }
  }
}