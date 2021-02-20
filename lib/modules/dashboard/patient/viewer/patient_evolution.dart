
import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/constant/assest_path.dart';
import 'package:parkinson_de_bolso/model/patient_classification_model.dart';
import 'package:parkinson_de_bolso/widget/custom_date_filter.dart';
import 'package:parkinson_de_bolso/widget/custom_dropdown_item.dart';
import 'package:parkinson_de_bolso/widget/custom_line_chart.dart';
import 'package:parkinson_de_bolso/widget/custom_no_data.dart';
import 'package:parkinson_de_bolso/widget/custom_table.dart';
import 'package:parkinson_de_bolso/widget/custom_toggle.dart';

class PatientEvolution extends StatefulWidget {
  final List<PatientClassificationModel> data;
  final double spacingBetweenFields;

  PatientEvolution({@required this.data, @required this.spacingBetweenFields});

  @override
  _PatientEvolutionState createState() => _PatientEvolutionState();
}

class _PatientEvolutionState extends State<PatientEvolution> {
  List<PatientClassificationModel> _data;
  List<PatientClassificationModel> _cacheData;
  DateTime _initialDate, _finalDate;
  bool _isViewData;

  @override
  void initState() {
    this._isViewData = false;
    this._initialDate = DateTime.now().subtract(Duration(days: 30));
    this._finalDate = DateTime.now();
    this.initializeData();
    super.initState();
  }

  void initializeData() {
    this._data = this.widget.data;
    this._data.sort((a, b) => a.date.compareTo(b.date));
    this._filter();
  }

  void _filter() {
    this._cacheData = this._data.where((element) => (element.date.year >= this._initialDate.year && element.date.year <= this._finalDate.year && element.date.month >= this._initialDate.month && element.date.month <= this._finalDate.month)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return (this._data.length > 0) ? 
    Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Evolução do Parkinson',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      letterSpacing: 1.0
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomDateFilter(
                    label: 'Data Inicial',
                    date: this._initialDate,
                    onSet: (date) {
                      this.setState(() => this._initialDate = date);
                      this._filter();
                    },
                  ),
                  CustomDateFilter(
                    label: 'Data Final',
                    date: this._finalDate,
                    onSet: (date) {
                      this.setState(() => this._finalDate = date);
                      this._filter();
                    },
                  ),
                ],
              ),
              
              Visibility(
                visible: this._initialDate.year == this._finalDate.year && this._initialDate.month <= this._finalDate.month,
                child: Container(
                  child: AnimatedCrossFade(
                    firstChild: CustomTable(
                      borderColor: primaryColor, 
                      data: this._cacheData, 
                      titles: ['Data', 'Porcentagem'],
                    ), 
                    secondChild: CustomLineChart(
                      data: this._cacheData
                    ), 
                    crossFadeState: this._isViewData ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
                    duration: Duration(milliseconds: 300)
                  ),
                ),
              ),
              Visibility(
                visible: this._initialDate.year == this._finalDate.year && this._initialDate.month <= this._finalDate.month,
                child: CustomToggle(
                  trackColor: Colors.indigo[800],
                  background: primaryColor,
                  action: (status) {
                    this.setState(() {
                      this._isViewData = status;
                    });
                  },
                  label: 'Visualizar dados',
                ),
              )
            ],
          ),
        ),
      ],
    ) : 
    CustomNoData(
      image: AssetImage(noData),
    );
  }

}