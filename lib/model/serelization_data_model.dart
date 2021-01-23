import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

abstract class SerelizationDataModel {
  FlSpot createSpot();
  TableRow createRow();
}