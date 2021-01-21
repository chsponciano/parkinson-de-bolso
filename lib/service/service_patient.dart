import 'package:parkinson_de_bolso/model/patient_model.dart';

class ServicePatient {
  ServicePatient._privateConstructor();
  static final ServicePatient instance = ServicePatient._privateConstructor();

  List<PatientModel> getAllPatient() {
    return <PatientModel>[
      PatientModel('José Vitor'),
      PatientModel('Vitor Miguel'),
      PatientModel('Ana Maria'),
      PatientModel('Ana Vitoria'),
      PatientModel('José Vitor'),
      PatientModel('Vitor Miguel'),
      PatientModel('Ana Maria'),
      PatientModel('Ana Vitoria'),
      PatientModel('José Vitor'),
      PatientModel('Vitor Miguel'),
      PatientModel('Ana Maria'),
      PatientModel('Ana Vitoria')
    ];
  }
}