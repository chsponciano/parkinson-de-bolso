import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/config/app_config.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';
import 'package:parkinson_de_bolso/service/aws_cognito_service.dart';

class PatientService {
  PatientService._privateConstructor();
  static final PatientService instance = PatientService._privateConstructor();
  final AwsCognitoService awsCognitoService = AwsCognitoService.instance;
  static final String path = '/api/patient';

  Future<List<PatientModel>> getAll() async {
    final SigV4Request signedRequest =
        this.awsCognitoService.getSigV4Request('GET', path);
    final http.Response response = await http.get(
        '${signedRequest.url}/userid/${AppConfig.instance.loggedInUser.id}',
        headers: signedRequest.headers);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => PatientModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  Future<PatientModel> create(PatientModel patient) async {
    final SigV4Request signedRequest = this
        .awsCognitoService
        .getSigV4Request('POST', path, body: patient.toJson(true));
    final http.Response response = await http.post(signedRequest.url,
        headers: signedRequest.headers, body: signedRequest.body);

    if (response.statusCode == 200) {
      return PatientModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load patient');
    }
  }

  Future<PatientModel> update(PatientModel patient) async {
    final SigV4Request signedRequest = this
        .awsCognitoService
        .getSigV4Request('PUT', path, body: patient.toJson(true));
    final http.Response response = await http.put(
        '${signedRequest.url}/${patient.id}',
        headers: signedRequest.headers,
        body: signedRequest.body);

    if (response.statusCode == 200) {
      return PatientModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update patient');
    }
  }

  Future<void> delete(String id) async {
    final SigV4Request signedRequest =
        this.awsCognitoService.getSigV4Request('DELETE', path);
    final http.Response response = await http.delete('${signedRequest.url}/$id',
        headers: signedRequest.headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete patient');
    }
  }
}
