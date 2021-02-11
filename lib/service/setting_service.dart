import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/model/patient_classification_model.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';
import 'package:parkinson_de_bolso/service/patient_classification_service.dart';
import 'package:parkinson_de_bolso/service/patient_service.dart';
import 'package:parkinson_de_bolso/service/user_service.dart';

class SettingService {
  SettingService._privateConstructor();
  static final SettingService instance = SettingService._privateConstructor();
  final PatientService _patientService = PatientService.instance;
  final PatientClassificationService _patientClassificationService = PatientClassificationService.instance;
  final UserService _userService = UserService.instance;

  Future<void> clearData() async {
    List<PatientModel> patients = await this._patientService.getAll();
    patients.forEach((patient) async {
      List<PatientClassificationModel> classifications = await this._patientClassificationService.getAll(patient.publicid);
      classifications.forEach((classification) async {
        await this._patientClassificationService.delete(classification.id);
      });
      await this._patientService.delete(patient.id);
    });
  }

  Future<void> deleteAccount() async {
    await this.clearData();
    await this._userService.delete(RouteHandler.loggedInUser.id);
  }
}