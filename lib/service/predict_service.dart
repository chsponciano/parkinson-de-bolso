import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/constant/http_constant.dart';
import 'package:parkinson_de_bolso/model/active_classification_model.dart';
import 'package:parkinson_de_bolso/model/execution_classification_model.dart';
import 'package:parkinson_de_bolso/model/patient_classification_model.dart';

class PredictService {
  PredictService._privateConstructor();
  static final PredictService instance = PredictService._privateConstructor();
  static final String apiPredictHost = '$api_host/predict';

  Future<ActiveClassificationModel> initialize() async {
    final http.Response response = await http.get(PredictService.apiPredictHost + '/start/' + RouteHandler.loggedInUser.publicid, 
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token' : RouteHandler.token
      }
    );

    if (response.statusCode == 200) {
      return ActiveClassificationModel.fromJson(jsonDecode(response.body)['response']);
    } else {
      throw Exception('Failed to initialize predict');
    }
  }

  Future<ExecutionClassificationModel> evaluator(int index, XFile image) async {
    try {
      final http.Response response = await http.post(PredictService.apiPredictHost + '/data', 
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token' : RouteHandler.token
        },
        body: jsonEncode({
          'patient_id': RouteHandler.loggedInUser.publicid,
          'index': index,
          'image': {
            'data': base64Encode(await image.readAsBytes()),
            'filename': image.path.split('/').last
          }
        })
      );

      if (response.statusCode == 200) {
        return ExecutionClassificationModel.fromJson(jsonDecode(response.body)['response']);
      } 

      return null;
    } catch (error) {
      return null;
    }
  }

  Future<PatientClassificationModel> conclude() async {
    final http.Response response = await http.get(PredictService.apiPredictHost + '/conclude/' + RouteHandler.loggedInUser.publicid, 
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token' : RouteHandler.token
      }
    );

    if (response.statusCode == 200) {
      return PatientClassificationModel.fromJson(jsonDecode(response.body)['response']);
    } else {
      throw Exception('Failed to conclude predict');
    }
  }
}