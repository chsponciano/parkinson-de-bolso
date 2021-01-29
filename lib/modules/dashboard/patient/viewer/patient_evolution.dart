
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
  final double spacingBetweenFields;

  PatientEvolution({@required this.data, @required this.spacingBetweenFields});

  @override
  _PatientEvolutionState createState() => _PatientEvolutionState();
}

class _PatientEvolutionState extends State<PatientEvolution> {
  List<PatientClassificationModel> _data;
  List<PatientClassificationModel> _cacheData;
  bool _isViewData;

  @override
  void initState() {
    this.initializeData();
    this._isViewData = false;
    super.initState();
  }

  void initializeData() {
    this._data = this.widget.data;
    this._data.sort((a, b) => a.date.year < b.date.year ? 1 : 0);
    this._cacheData = this._data.where((element) => element.date.year == this._data[0].date.year).toList();
  }

  void changeViewingYear(year) {
    this.setState(() {
      this._cacheData = this._data.where((element) => element.date.year == year).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return (this._cacheData.length > 0) ? 
    Column(
      children: [
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
                    items: this._data,
                    onChange: (ListItem item) => this.changeViewingYear(int.parse(item.name)),
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
                  crossFadeState: this._isViewData ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
                  duration: Duration(milliseconds: 300)
                ),
              ),
              SafeArea(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: ternaryColor
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [ 
                      Switch(
                        value: this._isViewData,
                        onChanged: (status) {
                          this.setState(() {
                            this._isViewData = status;
                          });
                        },
                        activeTrackColor: Colors.indigo[800],
                        activeColor: primaryColor,
                      ),
                      Text(
                        'Visualizar dados',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 15,
                        ),
                      )
                    ],
                  )
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