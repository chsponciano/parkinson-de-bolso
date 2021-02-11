import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/util/datetime_util.dart';
import 'package:parkinson_de_bolso/util/serelization_data_util.dart';

class CustomLineChart extends StatefulWidget {
  final List<FlSpot> spots;

  CustomLineChart({@required this.spots});

  static List<FlSpot> toListSpot(List<SerelizationDataUtil> item) {
    if (item == null)
      return null;
    return item.map((e) => e.createSpot()).toList();  
  }

  @override
  _CustomLineChartState createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> with DateTimeUtil {
  
  LineChartData _buildLineChartData() {

    return LineChartData(
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 8),
          getTitles: (value) => this.getMonth(value.toInt()),
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) => (value.toInt() * 10).toString()  + '%',
          reservedSize: 28,
          margin: 12,
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: this.widget.spots,
          isCurved: true,
          colors: defaultGradient.colors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: defaultGradient.colors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
          child: LineChart(
            this._buildLineChartData()
          ),
        ),
      ),
    );
  }
}