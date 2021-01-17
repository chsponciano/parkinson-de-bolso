import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';
import 'package:parkinson_de_bolso/widget/custom_list_search.dart';

class Dashboard extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _patients = <PatientModel>[];

  void _loadPatients() {
    _patients.add(PatientModel('José Vitor'));
    _patients.add(PatientModel('Vitor Miguel'));
    _patients.add(PatientModel('Ana Maria'));
    _patients.add(PatientModel('Ana Vitoria'));
  }

  @override
  void initState() {
    this._loadPatients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomListSearch(
      data: this._patients, 
      widgetName: 'Dashboard'
    );
  }
}