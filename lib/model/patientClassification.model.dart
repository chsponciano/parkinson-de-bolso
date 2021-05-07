import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:parkinson_de_bolso/model/tableRow.model.dart';
import 'package:parkinson_de_bolso/util/datetime.util.dart';
import 'package:parkinson_de_bolso/util/serelization.util.dart';

class PatientClassificationModel extends SerelizationDataUtil
    with DateTimeUtil {
  String id;
  DateTime date;
  double percentage;
  String patientid;

  PatientClassificationModel(
      {this.id, this.date, this.percentage, this.patientid});

  @override
  FlSpot createSpot(bool isAnnual) {
    return FlSpot(
        ((isAnnual) ? this.date.month : this.date.day).toDouble(), percentage);
  }

  @override
  TableRow createRow() {
    return TableRowModel(padding: EdgeInsets.all(5), values: <String>[
      this.format.format(this.date),
      this.percentage.toString()
    ]).create();
  }

  factory PatientClassificationModel.fromJson(Map<String, dynamic> json) {
    return PatientClassificationModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      percentage: double.parse(json['percentage'].toString()),
      patientid: json['patientid'],
    );
  }

  Map toJson(bool create) {
    return {
      if (!create) 'id': this.id,
      'date': DateFormat('yyyy-MM-dd')
          .format(this.date != null ? this.date : DateTime.now()),
      'patientid': this.patientid,
      'percentage': this.percentage.toInt()
    };
  }
}
