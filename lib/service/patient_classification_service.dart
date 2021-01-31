import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/config/route.dart';
import 'package:parkinson_de_bolso/constant/http_constant.dart';
import 'package:parkinson_de_bolso/model/patient_classification_model.dart';

class PatientClassificationService {
  PatientClassificationService._privateConstructor();
  static final PatientClassificationService instance = PatientClassificationService._privateConstructor();
  static final String apiPatienClassificationtHost = '$api_host/patient_classification';

  Future<List<PatientClassificationModel>> getAll(String patientId) async {
    final http.Response response = await http.get(PatientClassificationService.apiPatienClassificationtHost + '/patientid/$patientId', 
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token' : RouteHandler.token
      }
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['response'];
      return data.map((item) => PatientClassificationModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load patient classification');
    }
  }

  
  Future<bool> delete(String id) async {
    final http.Response response = await http.delete(PatientClassificationService.apiPatienClassificationtHost + '/$id', headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token' : RouteHandler.token
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    } else {
      throw Exception('Failed to delete patient classification');
    }
  }
}