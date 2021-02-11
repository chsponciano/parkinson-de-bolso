import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/constant/http_constant.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';

class PatientService {
  PatientService._privateConstructor();
  static final PatientService instance = PatientService._privateConstructor();
  static final String apiPatientHost = '$api_host/patient';

  Future<List<PatientModel>> getAll() async {
    final http.Response response = await http.get(PatientService.apiPatientHost + '/userid/' + RouteHandler.loggedInUser.publicid, 
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token' : RouteHandler.token
      }
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['response'];
      return data.map((item) => PatientModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  Future<PatientModel> create(PatientModel patient) async {
    final http.Response response = await http.post(PatientService.apiPatientHost, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token' : RouteHandler.token
    }, body: jsonEncode(patient.toJson(true)));

    if (response.statusCode == 200) {
      return PatientModel.fromJson(jsonDecode(response.body)['response']);
    } else {
      throw Exception('Failed to load patient');
    }
  }

  Future<PatientModel> update(PatientModel patient) async {
    final http.Response response = await http.put(PatientService.apiPatientHost, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token' : RouteHandler.token
    }, body: jsonEncode(patient.toJson(false)));

    if (response.statusCode == 200) {
      return PatientModel.fromJson(jsonDecode(response.body)['response']);
    } else {
      throw Exception('Failed to update patient');
    }
  }

  Future<bool> delete(String id) async {
    final http.Response response = await http.delete(PatientService.apiPatientHost + '/$id', headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token' : RouteHandler.token
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    } else {
      throw Exception('Failed to delete patient');
    }
  }
}