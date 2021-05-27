import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/dash.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/patient.model.dart';
import 'package:parkinson_de_bolso/modules/camera/camera.page.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/evolution.patient.dash.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/form.patient.dash.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/search.patient.dash.dart';
import 'package:parkinson_de_bolso/service/patient.service.dart';
import 'package:parkinson_de_bolso/service/patientClassification.service.dart';
import 'package:parkinson_de_bolso/service/predict.service.dart';
import 'package:parkinson_de_bolso/type/module.type.dart';
import 'package:parkinson_de_bolso/util/datetime.util.dart';
import 'package:parkinson_de_bolso/widget/circleAvatar.widget.dart';
import 'package:parkinson_de_bolso/widget/circularProgress.widget.dart';
import 'package:parkinson_de_bolso/widget/valueTitle.widget.dart';

class ViewPatientDash extends StatefulWidget {
  static const String routeName = '/patientView';
  final double horizontalPadding;
  final double spacingBetweenFields;
  final PatientModel patient;

  const ViewPatientDash({
    Key key,
    this.horizontalPadding = 10.0,
    this.spacingBetweenFields = 20.0,
    this.patient,
  }) : super(key: key);

  @override
  _ViewPatientDashState createState() => _ViewPatientDashState();
}

class _ViewPatientDashState extends State<ViewPatientDash> with DateTimeUtil {
  @override
  void didChangeDependencies() {
    DashConfig.instance.setContext(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int machineStatus = await PredictService.instance.machineStatus();

      DashConfig.instance.setBarAttributes(
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pushNamed(context, SearchPatientDash.routeName),
        ),
        null,
        [
          IconButton(
            icon: Icon(
              (machineStatus == 1) ? Icons.video_call : Icons.videocam_off,
            ),
            onPressed: (machineStatus == 1)
                ? () async {
                    AppConfig.instance.changeModule(ModuleType.CAMERA);
                    await CameraPage.processImageSequence(
                      context,
                      this.widget.patient,
                    );
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(
              context,
              FormPatientDash.routeName,
              arguments: {
                'patient': this.widget.patient,
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              PatientService.instance
                  .delete(this.widget.patient.id)
                  .whenComplete(
                    () => Navigator.pushNamed(
                      context,
                      SearchPatientDash.routeName,
                    ),
                  );
            },
          ),
        ],
      );
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: ThemeConfig.primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CircleAvatarWidget(
                  radius: 75,
                  background: ThemeConfig.ternaryColor,
                  foreground: ThemeConfig.primaryColor,
                  imagePath: this.widget.patient.imageUrl,
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      this.widget.patient.fullname.split(' ')[0],
                      style: TextStyle(
                        fontSize: 30,
                        color: ThemeConfig.ternaryColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(
                      height: this.widget.spacingBetweenFields,
                    ),
                    ValueTitleWidget(
                      size: 18,
                      title: 'Idade',
                      value: this
                              .getCurrentAge(
                                this.widget.patient.birthdate,
                              )
                              .toString() +
                          ' anos',
                      color: ThemeConfig.ternaryColor,
                    ),
                    SizedBox(
                      height: this.widget.spacingBetweenFields - 15,
                    ),
                    ValueTitleWidget(
                      size: 18,
                      title: 'Diagnóstico',
                      value: this
                              .getCurrentAge(
                                this.widget.patient.diagnosis,
                              )
                              .toString() +
                          ' anos',
                      color: ThemeConfig.ternaryColor,
                    ),
                    SizedBox(
                      height: this.widget.spacingBetweenFields - 15,
                    ),
                    ValueTitleWidget(
                      size: 18,
                      title: 'Peso',
                      value: this.widget.patient.weight + ' kg',
                      color: ThemeConfig.ternaryColor,
                    ),
                    SizedBox(
                      height: this.widget.spacingBetweenFields - 15,
                    ),
                    ValueTitleWidget(
                      size: 18,
                      title: 'Altura',
                      value: this.widget.patient.height + ' m',
                      color: ThemeConfig.ternaryColor,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: PatientClassificationService.instance.getAll(
            this.widget.patient.id,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return EvolutionPatientDash(
                data: snapshot.data,
              );
            } else {
              return CircularProgressWidget(
                valueColor: ThemeConfig.primaryColor,
              );
            }
          },
        )
      ],
    );
  }
}
