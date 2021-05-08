import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

abstract class SerelizationDataUtil {
  FlSpot createSpot(bool isAnnual);
  TableRow createRow(BuildContext context);
}
