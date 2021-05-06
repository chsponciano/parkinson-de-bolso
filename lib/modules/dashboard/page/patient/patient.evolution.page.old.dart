import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/patientClassification.model.dart';
import 'package:parkinson_de_bolso/util/datetime.util.dart';
import 'package:parkinson_de_bolso/widget/custom_dropdown_item.dart';
import 'package:parkinson_de_bolso/widget/custom_line_chart.dart';
import 'package:parkinson_de_bolso/widget/custom_no_data.dart';
import 'package:parkinson_de_bolso/widget/custom_table.dart';
import 'package:parkinson_de_bolso/widget/custom_toggle.dart';

class PatientEvolutionPage extends StatefulWidget {
  final List<PatientClassificationModel> data;
  final bool changeFilter;
  final double spacingBetweenFields;

  PatientEvolutionPage(
      {@required this.data,
      @required this.spacingBetweenFields,
      this.changeFilter});

  @override
  _PatientEvolutionPageState createState() => _PatientEvolutionPageState();
}

class _PatientEvolutionPageState extends State<PatientEvolutionPage>
    with DateTimeUtil {
  List<PatientClassificationModel> _data;
  List<PatientClassificationModel> _cacheData;
  List<ListItem> _dataYear;
  List<ListItem> _dataMonth;
  bool _annualFilter, _dataFilter;
  int _currentYear, _currentMonth;

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
      this._currentYear = this._dataYear[0].value;
      this._currentMonth = this._dataMonth.last.value;
      this._cacheData = this._data;
    }
  }

  List<ListItem> _getDataYears() {
    Set<int> years = Set();

    this._data.forEach((item) {
      years.add(item.date.year);
    });

    return years
        .map((e) => ListItem(e, e.toString()))
        .toList()
        .reversed
        .toList();
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

  void _normalizeData() {
    if (this._cacheData.length == 1) {
      DateTime currentDate = this._cacheData[0].date;
      DateTime previousDate =
          currentDate.subtract(Duration(days: (this._annualFilter) ? 31 : 1));

      this._cacheData = <PatientClassificationModel>[
        PatientClassificationModel(
          date: previousDate,
          percentage: this._cacheData[0].percentage - 5,
        ),
        this._cacheData[0]
      ];
    }
  }

  void averagePercentages() {
    Map<int, List<PatientClassificationModel>> percentages = Map();
    this._cacheData.forEach((element) {
      if (percentages.containsKey(element.date.month)) {
        percentages[element.date.month].add(element);
      } else {
        percentages.putIfAbsent(element.date.month, () => [element]);
      }
    });

    List<PatientClassificationModel> average = [];
    percentages.forEach((key, value) {
      double percentage =
          value.fold(0, (a, b) => a + b.percentage.toInt()) / value.length;
      average.add(PatientClassificationModel(
          date: value[0].date,
          percentage: double.parse(percentage.toStringAsFixed(2))));
    });

    this._cacheData = average;
  }

  void _filter() {
    if (this._annualFilter) {
      this._cacheData = this
          ._data
          .where((element) => element.date.year == this._currentYear)
          .toList();
      this.averagePercentages();
    } else {
      this._cacheData = this
          ._data
          .where((element) =>
              element.date.year == this._currentYear &&
              element.date.month == this._currentMonth)
          .toList();
    }

    this._normalizeData();
  }

  CustomLineChartDim _getChartDimensions() {
    PatientClassificationModel maxX = this
        ._cacheData
        .reduce((curr, next) => curr.date.isAfter(next.date) ? curr : next);
    PatientClassificationModel minX = this
        ._cacheData
        .reduce((curr, next) => curr.date.isBefore(next.date) ? curr : next);
    PatientClassificationModel maxY = this._cacheData.reduce(
        (curr, next) => curr.percentage > next.percentage ? curr : next);
    PatientClassificationModel minY = this._cacheData.reduce(
        (curr, next) => curr.percentage < next.percentage ? curr : next);

    return CustomLineChartDim(
        maxX:
            ((this._annualFilter) ? maxX.date.month : maxX.date.day).toDouble(),
        minX:
            ((this._annualFilter) ? minX.date.month : minX.date.day).toDouble(),
        maxY: maxY.percentage,
        minY: minY.percentage);
  }

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
                background: ThemeConfig.primaryColor,
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
                initialValue: this._dataYear[0],
                onChange: (ListItem item) => this.setState(() {
                  this._currentYear = item.value;
                  this._dataMonth = this._getDataMonths(this._currentYear);
                  this._currentMonth = this._dataMonth.last.value;
                }),
                color: ThemeConfig.primaryColor,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomToggle(
                trackColor: Colors.indigo[800],
                background: ThemeConfig.primaryColor,
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
                initialValue: this._dataMonth.last,
                onChange: (ListItem item) =>
                    this.setState(() => this._currentMonth = item.value),
                color: ThemeConfig.primaryColor,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _getDataScreen() {
    CustomLineChartDim _dimensions = this._getChartDimensions();
    return Column(
      children: [
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dados ' +
                  ((!this._annualFilter)
                      ? 'de ${this.months[this._currentMonth - 1]} '
                      : '') +
                  'de ${this._currentYear}',
              style: TextStyle(color: ThemeConfig.primaryColor, fontSize: 15),
            )
          ],
        ),
        Container(
          child: AnimatedCrossFade(
              firstChild: CustomTable(
                borderColor: ThemeConfig.primaryColor,
                data: this._cacheData,
                titles: ['Data', 'Porcentagem'],
              ),
              secondChild: CustomLineChart(
                  data: this._cacheData,
                  type: (this._annualFilter)
                      ? CustomLineChartType.ANNUAL
                      : CustomLineChartType.MONTHLY,
                  dimensions: _dimensions),
              crossFadeState: this._dataFilter
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 300)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this._data.length > 0) {
      this._filter();

      return Column(
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
                          color: ThemeConfig.primaryColor,
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
      );
    } else {
      return CustomNoData(image: AppConfig.instance.assetConfig.get('noData'));
    }
  }
}
