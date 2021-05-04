import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/adapter/aws.adpater.dart';
import 'package:parkinson_de_bolso/model/patientClassification.model.dart';

class PatientClassificationService {
  PatientClassificationService._privateConstructor();
  static final PatientClassificationService instance =
      PatientClassificationService._privateConstructor();
  final AwsAdapter awsAdapter = AwsAdapter.instance;
  static final String path = '/api/patient_classification';

  Future<List<PatientClassificationModel>> getAll(String patientId) async {
    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
          'GET',
          path,
        );

    final http.Response response = await http.get(
      '${signedRequest.url}/patientid/$patientId',
      headers: signedRequest.headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => PatientClassificationModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load patient classification');
    }
  }

  Future<void> delete(String id) async {
    final SigV4Request signedRequest =
        this.awsAdapter.getSigV4Request('DELETE', path);

    final http.Response response = await http.delete(
      '${signedRequest.url}/$id',
      headers: signedRequest.headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete patient classification');
    }
  }

  Future<PatientClassificationModel> create(
    PatientClassificationModel classification,
  ) async {
    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
          'POST',
          path,
          body: classification.toJson(true),
        );

    final http.Response response = await http.post(
      signedRequest.url,
      headers: signedRequest.headers,
      body: signedRequest.body,
    );

    if (response.statusCode == 200) {
      return PatientClassificationModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create classification');
    }
  }
}