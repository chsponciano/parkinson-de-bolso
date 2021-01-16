import 'package:diacritic/diacritic.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/constant/assest_path.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';


class Dashboard extends StatefulWidget {
  static const String routeName = '/dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<PatientModel> _patients = <PatientModel>[];

  List<PatientModel> _getAllPatients() {
    List<PatientModel> patients = [];
    patients.add(PatientModel('José Vitor'));
    patients.add(PatientModel('Vitor Miguel'));
    patients.add(PatientModel('Ana Maria'));
    patients.add(PatientModel('Ana Vitoria'));
    return patients;
  }

  Future<List<PatientModel>> search(String search) async {
    List<PatientModel> found = [];

    this._patients.forEach((patient) {
      if (removeDiacritics(patient.name.toLowerCase()).contains(removeDiacritics(search.toLowerCase()))) {
        found.add(patient);
      }
     });

    return found;
  }

  @override
  Widget build(BuildContext context) {
    this._patients = this._getAllPatients();
    
    //toolbar

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: defaultGradient
          ),
        ),
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                icon,
                fit: BoxFit.contain,
                height: 50,
              )
            ],
          )
        )
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<PatientModel>(
            onSearch: search,
            onItemFound: (PatientModel model, int index) {
              return ListTile(
                title: Text(model.name),
              );
            },
            suggestions: this._patients,
          ),
        ),
      )
    );
  }
}