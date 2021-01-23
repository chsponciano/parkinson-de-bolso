import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';

class PatientViewer extends StatefulWidget {
  final Function callHigher;
  final PatientModel selected;

  PatientViewer({Key key, @required this.callHigher, @required this.selected}) : super(key: key);

  @override
  _PatientViewerState createState() => _PatientViewerState();  
}

class _PatientViewerState extends State<PatientViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.selected.name),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp, 
            color: primaryColorDashboardBar
          ),
          onPressed: () => this.widget.callHigher.call(),
        ),
        backgroundColor: dashboardBarColor,
      )
    );
  }
}