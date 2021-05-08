import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/model/patient.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/notification/notification.dash.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/executation.patient.dash.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/form.patient.dash.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/search.patient.dash.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/view.patient.dash.dart';
import 'package:parkinson_de_bolso/modules/dashboard/report/report.dash.dart';

class RouteCache {
  static PatientModel patientModel;
}

RouteFactory dashRoutes() {
  return (settings) {
    final Map<String, dynamic> arguments = settings.arguments;

    Widget screen;
    switch (settings.name) {
      case SearchPatientDash.routeName:
        screen = SearchPatientDash();
        break;
      case NotificationDash.routeName:
        screen = NotificationDash(
          externalCall:
              arguments != null && arguments.containsKey('externalCall'),
        );
        break;
      case ExecutationPatientDash.routeName:
        screen = ExecutationPatientDash(
          id: arguments['id'],
          patient: RouteCache.patientModel,
          externalCall: arguments.containsKey('externalCall'),
        );
        break;
      case ReportDash.routeName:
        screen = ReportDash();
        break;
      case FormPatientDash.routeName:
        PatientModel _patient =
            (arguments != null) ? arguments['patient'] : null;
        screen = FormPatientDash(
          patient: _patient,
        );
        break;
      case ViewPatientDash.routeName:
        PatientModel _patient = arguments['patient'];
        RouteCache.patientModel = _patient;
        screen = ViewPatientDash(
          patient: _patient,
        );
        break;
      default:
        screen = SearchPatientDash();
        break;
    }

    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}
