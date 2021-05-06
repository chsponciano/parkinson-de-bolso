import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/patient.model.dart';
import 'package:parkinson_de_bolso/model/patientClassification.model.dart';
import 'package:parkinson_de_bolso/service/patientClassification.service.dart';
import 'package:parkinson_de_bolso/util/datetime.util.dart';
import 'package:parkinson_de_bolso/widget/custom_circular_progress.dart';
import 'package:parkinson_de_bolso/widget/custom_dropdown_item.dart';
import 'package:parkinson_de_bolso/widget/custom_line_chart.dart';
import 'package:parkinson_de_bolso/widget/custom_no_data.dart';
import 'package:parkinson_de_bolso/widget/custom_toggle.dart';

class PatientEvolutionPage extends StatefulWidget {
  final PatientModel patient;

  PatientEvolutionPage({
    @required this.patient,
  });

  @override
  _PatientEvolutionPageState createState() => _PatientEvolutionPageState();
}

class _PatientEvolutionPageState extends State<PatientEvolutionPage>
    with DateTimeUtil {
  List<PatientClassificationModel> _evolution, _cacheData;
  List<ListItem> _filterDataYear, _filterDataMonth;
  bool _viewTypeFilter, _groupTypeFilter;
  int _currentYear, _currentMonth;

  @override
  void initState() {
    this._viewTypeFilter = false;
    this._groupTypeFilter = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.getEvolution(this.widget.patient.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PatientClassificationModel> evolution = snapshot.data;
          this._evolution = evolution;

          if (evolution.length > 0) {
            this._loadFilterData(evolution);
            this._filter();
            return this._buildEvolutionScreen();
          } else {
            return CustomNoData(
              image: AppConfig.instance.assetConfig.get('noData'),
            );
          }
        } else {
          return CustomCircularProgress(
            valueColor: ThemeConfig.primaryColor,
          );
        }
      },
    );
  }

  Future<List<PatientClassificationModel>> getEvolution(String id) async {
    List<PatientClassificationModel> evolution =
        await PatientClassificationService.instance.getAll(id);
    evolution.sort((a, b) => a.date.compareTo(b.date));
    return evolution;
  }

  void _loadFilterData(List<PatientClassificationModel> evolution) {
    this._filterDataYear = this._buildYearFilterData();
    if (this._filterDataYear.isNotEmpty) {
      this._currentYear = this._filterDataYear[0].value;
      this._filterDataMonth = this._buildMonthFilterData(this._currentYear);
      this._currentMonth = this._filterDataMonth[0].value;
    }
  }

  List<ListItem> _buildYearFilterData() {
    Set<int> years = Set();
    this._evolution.forEach((item) => years.add(item.date.year));
    return years
        .map((e) => ListItem(e, e.toString()))
        .toList()
        .reversed
        .toList();
  }

  List<ListItem> _buildMonthFilterData(int year) {
    Set<int> months = Set();
    this._evolution.forEach((item) {
      if (item.date.year == year) {
        months.add(item.date.month);
      }
    });
    return months.map((e) => ListItem(e, this.getMonth(e - 1))).toList();
  }

  void _normalizeData() {
    if (this._cacheData.length == 1) {
      DateTime currentDate = this._cacheData[0].date;
      DateTime previousDate = currentDate
          .subtract(Duration(days: (this._groupTypeFilter) ? 31 : 1));

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
    if (this._groupTypeFilter) {
      this._cacheData = this
          ._evolution
          .where((element) => element.date.year == this._currentYear)
          .toList();
      this.averagePercentages();
    } else {
      this._cacheData = this
          ._evolution
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
        maxX: ((this._groupTypeFilter) ? maxX.date.month : maxX.date.day)
            .toDouble(),
        minX: ((this._groupTypeFilter) ? minX.date.month : minX.date.day)
            .toDouble(),
        maxY: maxY.percentage,
        minY: minY.percentage);
  }

  Widget _buildEvolutionScreen() {
    CustomLineChartDim _dimensions = this._getChartDimensions();

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
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              this._buildEvolutionFilter(),
              CustomLineChart(
                  data: this._cacheData,
                  type: (this._groupTypeFilter)
                      ? CustomLineChartType.ANNUAL
                      : CustomLineChartType.MONTHLY,
                  dimensions: _dimensions)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEvolutionFilter() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomToggle(
                trackColor: Colors.indigo[800],
                background: ThemeConfig.primaryColor,
                action: (status) => this.setState(() {
                  this._viewTypeFilter = !this._viewTypeFilter;
                }),
                label: (this._viewTypeFilter) ? 'Dados' : 'Gráfico',
              ),
              CustomToggle(
                trackColor: Colors.indigo[800],
                background: ThemeConfig.primaryColor,
                action: (status) => this.setState(() {
                  this._groupTypeFilter = !this._groupTypeFilter;
                }),
                label: (this._groupTypeFilter) ? 'Anual' : 'Mensal',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomDropdownItem(
                label: 'Ano: ',
                items: this._filterDataYear,
                initialValue: this._filterDataYear[0],
                onChange: (ListItem item) => print(item),
                color: ThemeConfig.primaryColor,
              ),
              CustomDropdownItem(
                disabled: this._groupTypeFilter,
                label: 'Mês: ',
                items: this._filterDataMonth,
                initialValue: this._filterDataMonth.last,
                onChange: (ListItem item) => print(item),
                color: ThemeConfig.primaryColor,
              ),
            ],
          )
        ],
      ),
    );
  }
}
