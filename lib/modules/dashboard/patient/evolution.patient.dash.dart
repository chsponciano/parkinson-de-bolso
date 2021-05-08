import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/model/patientClassification.model.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/table/table.patient.dart';
import 'package:parkinson_de_bolso/util/datetime.util.dart';
import 'package:parkinson_de_bolso/widget/dropdownItem.widget.dart';
import 'package:parkinson_de_bolso/widget/lineChart.widget.dart';
import 'package:parkinson_de_bolso/widget/noData.widget.dart';
import 'package:parkinson_de_bolso/widget/toggle.widget.dart';

class EvolutionPatientDash extends StatefulWidget {
  final List<PatientClassificationModel> data;

  const EvolutionPatientDash({Key key, @required this.data}) : super(key: key);

  @override
  _EvolutionPatientDashState createState() => _EvolutionPatientDashState();
}

class _EvolutionPatientDashState extends State<EvolutionPatientDash>
    with DateTimeUtil {
  List<ListItem> _filterDataYear, _filterDataMonth;
  List<PatientClassificationModel> _data, _cacheData;
  bool _annualFilter, _dataFilter;
  int _currentYear, _currentMonth;

  @override
  void initState() {
    this._annualFilter = true;
    this._dataFilter = false;
    this.initializeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (this._data.length == 0) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 30),
        child: NoDataWidget(
          image: AppConfig.instance.assetConfig.get('noData'),
        ),
      );
    }

    this._filter();
    return Column(
      children: [
        this._buildFilter(),
        this._buildDataViewer(),
      ],
    );
  }

  Widget _buildDataViewer() {
    LineChartDimWidget _dimensions = this._getChartDimensions();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: ToggleWidget(
                trackColor: Colors.indigo[800],
                background: ThemeConfig.primaryColor,
                initial: this._dataFilter,
                action: (status) => this.setState(
                  () => this._dataFilter = status,
                ),
                label: 'Tabela Completa',
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: AnimatedCrossFade(
              firstChild: TablePatient(
                borderColor: ThemeConfig.primaryColor,
                data: this._cacheData,
                titles: ['Data', 'Taxa', ''],
              ),
              secondChild: LineChartWidget(
                  data: this._cacheData,
                  type: (this._annualFilter)
                      ? LineChartTypeWidget.ANNUAL
                      : LineChartTypeWidget.MONTHLY,
                  dimensions: _dimensions),
              crossFadeState: this._dataFilter
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 300)),
        ),
      ],
    );
  }

  Widget _buildFilter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownItemWidget(
            label: 'Ano: ',
            items: this._filterDataYear,
            initialValue: this._filterDataYear[0],
            onChange: (ListItem item) => this.setState(() {
              this._currentYear = item.value;
              this._filterDataMonth = this._getDataMonths(this._currentYear);
              this._currentMonth = this._filterDataMonth.last.value;
            }),
            color: ThemeConfig.primaryColor,
          ),
          DropdownItemWidget(
            disabled: this._annualFilter,
            label: 'Mês: ',
            items: this._filterDataMonth,
            initialValue: this._filterDataMonth.last,
            onChange: (ListItem item) => this.setState(
              () => this._currentMonth = item.value,
            ),
            color: ThemeConfig.primaryColor,
          ),
          ToggleWidget(
            trackColor: Colors.indigo[800],
            background: ThemeConfig.primaryColor,
            initial: this._annualFilter,
            action: (status) => this.setState(
              () => this._annualFilter = status,
            ),
            label: 'Anual',
          ),
        ],
      ),
    );
  }

  void initializeData() {
    this._data = this.widget.data;

    if (this._data.length > 0) {
      this._data.sort((a, b) => a.date.compareTo(b.date));
      this._filterDataYear = this._getDataYears();
      this._filterDataMonth =
          this._getDataMonths(this._filterDataYear[0].value);
      this._currentYear = this._filterDataYear[0].value;
      this._currentMonth = this._filterDataMonth.last.value;
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
          isParkinson: this._cacheData[0].isParkinson,
          executationid: this._cacheData[0].executationid,
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
      average.add(
        PatientClassificationModel(
          date: value[0].date,
          percentage: double.parse(percentage.toStringAsFixed(7)),
          executationid: value[0].executationid,
          isParkinson: value[0].isParkinson,
        ),
      );
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

  LineChartDimWidget _getChartDimensions() {
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

    return LineChartDimWidget(
        maxX:
            ((this._annualFilter) ? maxX.date.month : maxX.date.day).toDouble(),
        minX:
            ((this._annualFilter) ? minX.date.month : minX.date.day).toDouble(),
        maxY: maxY.percentage,
        minY: minY.percentage);
  }
}
