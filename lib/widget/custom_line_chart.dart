import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/theme.config.dart';
import 'package:parkinson_de_bolso/util/datetime.util.dart';
import 'package:parkinson_de_bolso/util/serelization.util.dart';

enum CustomLineChartType { ANNUAL, MONTHLY }

class CustomLineChartDim {
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  CustomLineChartDim(
      {this.minX = 0.0, this.maxX = 0.0, this.minY = 0.0, this.maxY = 0.0});
}

class CustomLineChart extends StatefulWidget {
  final List<SerelizationDataUtil> data;
  final CustomLineChartType type;
  final CustomLineChartDim dimensions;

  CustomLineChart({this.data, this.type, this.dimensions});

  @override
  _CustomLineChartState createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> with DateTimeUtil {
  LineChartData _buildLineChartData() {
    return LineChartData(
      minX: this.widget.dimensions.minX,
      maxX: this.widget.dimensions.maxX,
      minY: this.widget.dimensions.minY,
      maxY: this.widget.dimensions.maxY,
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => TextStyle(
              color: ThemeConfig.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 8),
          getTitles: (value) => (this.widget.type == CustomLineChartType.ANNUAL)
              ? this.getMonth(value.toInt() - 1)
              : value.toInt().toString(),
          margin: 8,
        ),
        leftTitles: SideTitles(
          interval:
              (this.widget.dimensions.maxY - this.widget.dimensions.minY) / 3,
          showTitles: true,
          getTextStyles: (value) => TextStyle(
            color: ThemeConfig.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) => (value.toInt()).toString() + '%',
          reservedSize: 28,
          margin: 12,
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: this
              .widget
              .data
              .map((SerelizationDataUtil e) =>
                  e.createSpot(this.widget.type == CustomLineChartType.ANNUAL))
              .toList(),
          isCurved: true,
          colors: ThemeConfig.defaultGradient.colors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            colors: ThemeConfig.defaultGradient.colors
                .map((color) => color.withOpacity(0.8))
                .toList(),
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
          padding:
              EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
          child: LineChart(this._buildLineChartData()),
        ),
      ),
    );
  }
}
