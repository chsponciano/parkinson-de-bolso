import 'package:parkinson_de_bolso/model/patient_model.dart';

class ServicePatient {
  ServicePatient._privateConstructor();
  static final ServicePatient instance = ServicePatient._privateConstructor();

  List<PatientModel> getAllPatient() {
    return <PatientModel>[
      PatientModel(name: 'José Vitor'),
      PatientModel(name: 'Vitor Miguel'),
      PatientModel(name: 'Ana Maria'),
      PatientModel(name: 'Ana Vitoria'),
      PatientModel(name: 'José Vitor'),
      PatientModel(name: 'Vitor Miguel'),
      PatientModel(name: 'Ana Maria'),
      PatientModel(name: 'Ana Vitoria'),
      PatientModel(name: 'José Vitor'),
      PatientModel(name: 'Vitor Miguel'),
      PatientModel(name: 'Ana Maria'),
      PatientModel(name: 'Ana Vitoria')
    ];
  }
}