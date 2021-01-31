import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/patient_model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/viewer/patient_evolution.dart';
import 'package:parkinson_de_bolso/service/patient_classification_service.dart';
import 'package:parkinson_de_bolso/service/patient_service.dart';
import 'package:parkinson_de_bolso/util/datetime_util.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';
import 'package:parkinson_de_bolso/widget/custom_circle_avatar.dart';
import 'package:parkinson_de_bolso/widget/custom_circular_progress.dart';
import 'package:parkinson_de_bolso/widget/custom_value_title.dart';

class PatientViewer extends StatefulWidget {
  final Function callHigher;
  final Function callEdition;
  final Function callRemoval;
  final PatientModel patient;
  final double horizontalPadding;
  final double spacingBetweenFields;

  PatientViewer({Key key, @required this.callHigher, @required this.patient, this.horizontalPadding = 10.0, this.spacingBetweenFields = 20.0, @required this.callEdition, @required this.callRemoval}) : super(key: key);

  @override
  _PatientViewerState createState() => _PatientViewerState();  
}

class _PatientViewerState extends State<PatientViewer> with DateTimeUtil {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          tooltip: 'Voltar',
          icon: Icon(
            Icons.arrow_back_sharp, 
            color: primaryColorDashboardBar
          ),
          onPressed: () => this.widget.callHigher.call(),
        ),
        actions: [
          IconButton(
            tooltip: 'Classificador de parkinson',
            icon: Icon(
                Icons.video_call, 
                color: primaryColorDashboardBar
              ),
            onPressed: () => print('camera'),
          ),
          IconButton(
            tooltip: 'Editar',
            icon: Icon(
                Icons.edit, 
                color: primaryColorDashboardBar
              ),
            onPressed: () => this.widget.callEdition.call(),
          ),
          IconButton(
            tooltip: 'Excluir',
            icon: Icon(
                Icons.delete, 
                color: primaryColorDashboardBar
              ),
            onPressed: () {
              PatientService.instance.delete(this.widget.patient.id).then((value) => this.widget.callRemoval.call());
            },
          ),
        ],
        backgroundColor: dashboardBarColor,
      ),
      body: CustomBackground(
        topColor: dashboardBarColor, 
        bottomColor: ternaryColor,
        horizontalPadding: this.widget.horizontalPadding,
        margin: 50.0,
        top: Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomCircleAvatar(
                  radius: 75, 
                  background: ternaryColor, 
                  foreground: primaryColor,
                  imagePath: this.widget.patient.imageUrl,
                  initials: this.widget.patient.initials,
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(this.widget.patient.name.split(' ')[0],
                      style: TextStyle(
                        fontSize: 30,
                        color: ternaryColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0
                      ),
                    ),
                    SizedBox(height: this.widget.spacingBetweenFields),
                    CustomValueTitle(
                      size: 18,
                      title: 'Idade',
                      value: this.getCurrentAge(this.widget.patient.birthdate).toString() + ' anos',
                      color: ternaryColor,
                    ),
                    SizedBox(height: this.widget.spacingBetweenFields - 15),
                    CustomValueTitle(
                      size: 18,
                      title: 'Diagnóstico',
                      value: this.getCurrentAge(this.widget.patient.diagnosis).toString() + ' anos',
                      color: ternaryColor,
                    ),
                    SizedBox(height: this.widget.spacingBetweenFields - 15),
                    CustomValueTitle(
                      size: 18,
                      title: 'Peso',
                      value: this.widget.patient.weight.toInt().toString() + ' kg',
                      color: ternaryColor,
                    ),
                    SizedBox(height: this.widget.spacingBetweenFields - 15),
                    CustomValueTitle(
                      size: 18,
                      title: 'Altura',
                      value: this.widget.patient.height.toString() + ' m',
                      color: ternaryColor,
                    )
                  ],
                ),
              ),
            ],
          ),
        ), 
        bottom: FutureBuilder(
          future: PatientClassificationService.instance.getAll(this.widget.patient.publicid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PatientEvolution(
                data: snapshot.data,
                spacingBetweenFields: this.widget.spacingBetweenFields,
              );
            } else {
              return CustomCircularProgress(
                valueColor: primaryColor,
              );
            }
          },
        ),
      ),
    );
  }
}