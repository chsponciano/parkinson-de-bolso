import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/patient.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/action/dashboard.actions.dart';
import 'package:parkinson_de_bolso/modules/dashboard/page/patient/patient.evolution.page.dart';
import 'package:parkinson_de_bolso/util/datetime.util.dart';
import 'package:parkinson_de_bolso/widget/custom_background.dart';
import 'package:parkinson_de_bolso/widget/custom_circle_avatar.dart';
import 'package:parkinson_de_bolso/widget/custom_value_title.dart';

class PatientViewerPage extends StatefulWidget {
  final double horizontalPadding;
  final double spacingBetweenFields;
  final PatientModel patient;

  PatientViewerPage({
    Key key,
    this.horizontalPadding = 10.0,
    this.spacingBetweenFields = 20.0,
    @required this.patient,
  }) : super(key: key);

  @override
  _PatientViewerPageState createState() => _PatientViewerPageState();
}

class _PatientViewerPageState extends State<PatientViewerPage>
    with DateTimeUtil {
  // bool _changeFilter;

  @override
  void initState() {
    // this._changeFilter = false;
    DashboardActions.instance.setAttibuteProcessImageSequence(
      context,
      this.widget.patient,
    );
    super.initState();
  }

  // Widget _getPatientEvolution(
  //   List<PatientClassificationModel> data,
  //   bool changeFilter,
  // ) {
  //   return PatientEvolutionPage(
  //     data: data,
  //     changeFilter: changeFilter,
  //     spacingBetweenFields: this.widget.spacingBetweenFields,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        topColor: ThemeConfig.dashboardBarColor,
        bottomColor: ThemeConfig.ternaryColor,
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
                    CustomValueTitle(
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
                    CustomValueTitle(
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
                    CustomValueTitle(
                      size: 18,
                      title: 'Peso',
                      value: this.widget.patient.weight + ' kg',
                      color: ThemeConfig.ternaryColor,
                    ),
                    SizedBox(
                      height: this.widget.spacingBetweenFields - 15,
                    ),
                    CustomValueTitle(
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
        bottom: PatientEvolutionPage(
          patient: this.widget.patient,
        ),

        //   (this._data == null)
        //       ? FutureBuilder(
        //           future: PatientClassificationService.instance.getAll(
        //             this.widget.patient.id,
        //           ),
        //           builder: (context, snapshot) {
        //             if (snapshot.hasData) {
        //               return this._getPatientEvolution(
        //                 snapshot.data,
        //                 this._changeFilter,
        //               );
        //             } else {
        //               return CustomCircularProgress(
        //                 valueColor: ThemeConfig.primaryColor,
        //               );
        //             }
        //           },
        //         )
        //       : this._getPatientEvolution(
        //           _data,
        //           this._changeFilter,
        //         ),
        // ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => this.setState(
        //     () => this._changeFilter = !this._changeFilter,
        //   ),
        //   tooltip: (this._changeFilter) ? 'Visualizar dados' : 'Filtrar dados',
        //   child: Icon(
        //     (this._changeFilter) ? Icons.bar_chart : Icons.filter_list_alt,
        //     color: ThemeConfig.primaryColorDashboardBar,
        //     size: 40,
        //   ),
        //   backgroundColor: ThemeConfig.floatingButtonDashboard,
      ),
    );
  }
}
