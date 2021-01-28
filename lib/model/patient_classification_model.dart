import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:parkinson_de_bolso/model/serelization_data_model.dart';
import 'package:parkinson_de_bolso/util/datetime_util.dart';
import 'package:parkinson_de_bolso/widget/custom_table_row.dart';

class PatientClassificationModel extends SerelizationDataModel with DateTimeUtil{
  String id;
  DateTime date;
  double percentage;

  PatientClassificationModel({this.id, this.date, this.percentage});

  @override
  FlSpot createSpot() {
    return FlSpot(this.millisecondsToMonth(date.millisecondsSinceEpoch).toDouble(), percentage / 10);
  }

  @override
  TableRow createRow() {
    return CustomTableRow(
      padding: EdgeInsets.all(5),
      values: <String>[this.format.format(this.date), this.percentage.toString()]
    ).build();
  }

  factory PatientClassificationModel.fromJson(Map<String, dynamic> json) {
    return PatientClassificationModel(
      id: json['_id'],
      date: DateTime.parse(json['date']),
      percentage: double.parse(json['percentage'])
    );
  }
  
  Map toJson(bool create) {
    return {
      if(!create)
        '_id': this.id,
      'date': DateFormat('yyyy-MM-dd').format(this.date),
      'percentage': this.percentage      
    };
  }

}