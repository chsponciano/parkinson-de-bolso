import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/constant/assest_path.dart';
import 'package:parkinson_de_bolso/model/patient_classification_model.dart';
import 'package:parkinson_de_bolso/util/datetime_util.dart';
import 'package:parkinson_de_bolso/widget/custom_dropdown_item.dart';
import 'package:parkinson_de_bolso/widget/custom_line_chart.dart';
import 'package:parkinson_de_bolso/widget/custom_no_data.dart';
import 'package:parkinson_de_bolso/widget/custom_table.dart';
import 'package:parkinson_de_bolso/widget/custom_toggle.dart';

class PatientEvolution extends StatefulWidget {
  final List<PatientClassificationModel> data;
  final bool changeFilter;
  final double spacingBetweenFields;

  PatientEvolution(
      {@required this.data,
      @required this.spacingBetweenFields,
      this.changeFilter});

  @override
  _PatientEvolutionState createState() => _PatientEvolutionState();
}

class _PatientEvolutionState extends State<PatientEvolution> with DateTimeUtil {
  List<PatientClassificationModel> _data;
  List<PatientClassificationModel> _cacheData;
  List<ListItem> _dataYear;
  List<ListItem> _dataMonth;
  bool _annualFilter, _dataFilter;

  @override
  void initState() {
    this._annualFilter = false;
    this._dataFilter = false;
    this.initializeData();
    super.initState();
  }

  void initializeData() {
    this._data = this.widget.data;
    if (this._data.length > 0) {
      this._data.sort((a, b) => a.date.compareTo(b.date));
      this._dataYear = this._getDataYears();
      this._dataMonth = this._getDataMonths(this._dataYear[0].value);
      this._cacheData = this._data;
    }
  }

  List<ListItem> _getDataYears() {
    Set<int> years = Set();

    this._data.forEach((item) {
      years.add(item.date.year);
    });

    return years.map((e) => ListItem(e, e.toString())).toList();
  }

  List<ListItem> _getDataMonths(int year) {
    Set<int> months = Set();

    this._data.forEach((item) {
      if (item.date.year == year) {
        months.add(item.date.month);
      }
    });

    return months.map((e) => ListItem(e, this.getMonth(e - 1))).toList();
  }

  // void _filter() {
  //   this._cacheData = this
  //       ._data
  //       .where((element) => (element.date.year >= this._initialDate.year &&
  //           element.date.year <= this._finalDate.year &&
  //           element.date.month >= this._initialDate.month &&
  //           element.date.month <= this._finalDate.month))
  //       .toList();
  // }

  Widget _getFilterScreen() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomToggle(
                trackColor: Colors.indigo[800],
                background: primaryColor,
                action: (status) {
                  this.setState(() {
                    this._annualFilter = status;
                  });
                },
                label: (this._annualFilter) ? 'Anual' : 'Mensal',
              ),
              CustomDropdownItem(
                label: 'Ano: ',
                items: this._dataYear,
                onChange: (ListItem item) => print(item),
                color: primaryColor,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomToggle(
                trackColor: Colors.indigo[800],
                background: primaryColor,
                action: (status) {
                  this.setState(() {
                    this._dataFilter = status;
                  });
                },
                label: (this._dataFilter) ? 'Dados' : 'Gráfico',
              ),
              CustomDropdownItem(
                disabled: this._annualFilter,
                label: 'Mês: ',
                items: this._dataMonth,
                onChange: (ListItem item) => print(item),
                color: primaryColor,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _getDataScreen() {
    return Container(
      child: AnimatedCrossFade(
          firstChild: CustomTable(
            borderColor: primaryColor,
            data: this._cacheData,
            titles: ['Data', 'Porcentagem'],
          ),
          secondChild: CustomLineChart(data: this._cacheData),
          crossFadeState: this._dataFilter
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 300)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (this._data.length > 0)
        ? Column(
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
                              letterSpacing: 1.0),
                        ),
                      ],
                    ),
                    AnimatedCrossFade(
                      firstChild: this._getFilterScreen(),
                      secondChild: this._getDataScreen(),
                      crossFadeState: this.widget.changeFilter
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 300),
                    )
                  ],
                ),
              ),
            ],
          )
        : CustomNoData(
            image: AssetImage(noData),
          );
  }
}
