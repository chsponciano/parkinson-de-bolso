
import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/constant/assest_path.dart';
import 'package:parkinson_de_bolso/model/patient_classification_model.dart';
import 'package:parkinson_de_bolso/widget/custom_dropdown_item.dart';
import 'package:parkinson_de_bolso/widget/custom_line_chart.dart';
import 'package:parkinson_de_bolso/widget/custom_no_data.dart';
import 'package:parkinson_de_bolso/widget/custom_table.dart';

class PatientEvolution extends StatefulWidget {
  final List<PatientClassificationModel> data;
  final bool isViewData;
  final double spacingBetweenFields;

  PatientEvolution({@required this.data, @required this.isViewData, @required this.spacingBetweenFields});

  @override
  _PatientEvolutionState createState() => _PatientEvolutionState();
}

class _PatientEvolutionState extends State<PatientEvolution> {
  List<PatientClassificationModel> _cacheData;

  @override
  void initState() {
    this._cacheData = this.widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (this._cacheData.length > 0) ? 
    Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Evolução do Parkinson',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  letterSpacing: 1.0
                ),
              ),
              CustomDropdownItem(
                items: this._cacheData,
                onChange: (v) => print(v),
                color: primaryColor,
              )
            ],
          ),
          SizedBox(height: this.widget.spacingBetweenFields),
          Container(
            child: AnimatedCrossFade(
              firstChild: CustomTable(
                borderColor: primaryColor, 
                data: this._cacheData, 
                titles: ['Data', 'Porcentagem'],
              ), 
              secondChild: CustomLineChart(
                spots: CustomLineChart.toListSpot(this._cacheData)
              ), 
              crossFadeState: this.widget.isViewData ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
              duration: Duration(milliseconds: 300)
            ),
          ),
        ],
      ),
    ) : 
    CustomNoData(
      image: AssetImage(noData),
    );
  }

}