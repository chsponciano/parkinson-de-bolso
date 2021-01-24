import 'dart:io';

import 'package:parkinson_de_bolso/model/patien_classification_model.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';
import 'package:parkinson_de_bolso/util/string_util.dart';

class ServicePatient {
  ServicePatient._privateConstructor();
  static final ServicePatient instance = ServicePatient._privateConstructor();

  List<PatientModel> getAllPatient() {
    return <PatientModel>[
      PatientModel(
        name: 'José Vitor',
        birthDate: DateTime.utc(1970, 12, 1),
        diagnosis: DateTime.utc(2015, 1, 5),
        height: 1.70,
        weight: 70,
        initials: StringUtil.getInitials('José Vitor'),
        photo: File('/storage/emulated/0/DCIM/Camera/IMG_20210124_164649.jpg'),
        classifications: <PatientClassificationModel>[
          PatientClassificationModel(
            date: DateTime.utc(2021, 1, 1),
            percentage: 50.0
          ),
          PatientClassificationModel(
            date: DateTime.utc(2021, 2, 1),
            percentage: 62.0
          ),
          PatientClassificationModel(
            date: DateTime.utc(2021, 3, 1),
            percentage: 70.0
          ),
          PatientClassificationModel(
            date: DateTime.utc(2021, 4, 1),
            percentage: 65.0
          ),
          PatientClassificationModel(
            date: DateTime.utc(2021, 5, 1),
            percentage: 68.0
          ),
          PatientClassificationModel(
            date: DateTime.utc(2021, 6, 1),
            percentage: 74.0
          ),
          PatientClassificationModel(
            date: DateTime.utc(2021, 7, 1),
            percentage: 80.0
          ),
        ]
      ),
      PatientModel(
        name: 'Vitor Miguel',
        birthDate: DateTime.utc(1965, 11, 21),
        diagnosis: DateTime.utc(2008, 8, 15),
        height: 1.90,
        weight: 98,
        initials: StringUtil.getInitials('Vitor Miguel')
      ),
      PatientModel(
        name: 'Ana Maria',
        birthDate: DateTime.utc(1985, 3, 15),
        diagnosis: DateTime.utc(2018, 5, 28),
        height: 1.55,
        weight: 62,
        initials: StringUtil.getInitials('Ana Maria')
      ),
    ];
  }
}