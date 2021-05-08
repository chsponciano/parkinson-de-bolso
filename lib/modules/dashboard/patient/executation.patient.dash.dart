import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkinson_de_bolso/config/dash.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/execution.model.dart';
import 'package:parkinson_de_bolso/model/patient.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/view.patient.dash.dart';
import 'package:parkinson_de_bolso/service/predict.service.dart';
import 'package:parkinson_de_bolso/widget/circleAvatar.widget.dart';
import 'package:parkinson_de_bolso/widget/circularProgress.widget.dart';

class ExecutationPatientDash extends StatefulWidget {
  static const String routeName = '/patientEvolution';
  final PatientModel patient;
  final String id;

  const ExecutationPatientDash({
    Key key,
    this.id,
    this.patient,
  }) : super(key: key);

  @override
  _ExecutationPatientDashState createState() => _ExecutationPatientDashState();
}

class _ExecutationPatientDashState extends State<ExecutationPatientDash> {
  @override
  void didChangeDependencies() {
    DashConfig.instance.setContext(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DashConfig.instance.setBarAttributes(
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(
              context,
              ViewPatientDash.routeName,
              arguments: {
                'patient': this.widget.patient,
              },
            ),
          ),
          Text('Detalhes'),
          null);
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: this._buildContent(),
        ),
      ),
    );
  }

  _buildContent() {
    return FutureBuilder(
      future: PredictService.instance.getAll(this.widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ExecutionModel> data = snapshot.data;
          data.sort(
            (a, b) => a.index > b.index ? 1 : 0,
          );
          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return this._buildCard(data[index]);
            },
          );
        } else {
          return Center(
            child: Container(
              child: CircularProgressWidget(
                valueColor: ThemeConfig.primaryColor,
              ),
            ),
          );
        }
      },
    );
  }

  _buildCard(ExecutionModel execution) {
    return ListTile(
      title: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ThemeConfig.secondaryColorDashboardBar,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatarWidget(
              radius: 50,
              background: ThemeConfig.secondaryColor,
              foreground: ThemeConfig.ternaryColor,
              imagePath: execution.image,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ID: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('#' +
                        this.widget.id.substring(1, 5) +
                        '-' +
                        execution.index.toString()),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Parkinson: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(execution.isParkinson == 1 ? 'Sim' : 'Não'),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Porcentagem: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(execution.percentage.toStringAsPrecision(7) + '%'),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
