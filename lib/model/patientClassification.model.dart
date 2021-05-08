import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/table/table.row.patient.dah.dart';
import 'package:parkinson_de_bolso/util/datetime.util.dart';
import 'package:parkinson_de_bolso/util/serelization.util.dart';

class PatientClassificationModel extends SerelizationDataUtil
    with DateTimeUtil {
  String id;
  DateTime date;
  double percentage;
  String patientid;
  int isParkinson;
  String executationid;

  PatientClassificationModel({
    this.id,
    this.date,
    this.percentage,
    this.patientid,
    this.isParkinson,
    this.executationid,
  });

  @override
  FlSpot createSpot(bool isAnnual) {
    return FlSpot(
        ((isAnnual) ? this.date.month : this.date.day).toDouble(), percentage);
  }

  @override
  TableRow createRow(BuildContext context) {
    return TableRowPatientDash(padding: EdgeInsets.all(5), values: <String>[
      this.format.format(this.date),
      this.percentage.toStringAsPrecision(7),
      '*' + this.executationid,
    ]).create(context);
  }

  factory PatientClassificationModel.fromJson(Map<String, dynamic> json) {
    return PatientClassificationModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      percentage: double.parse(json['percentage'].toString()),
      patientid: json['patientid'],
      isParkinson: json['isParkinson'],
      executationid: json['executationid'].toString(),
    );
  }

  Map toJson(bool create) {
    return {
      if (!create) 'id': this.id,
      'date': DateFormat('yyyy-MM-dd')
          .format(this.date != null ? this.date : DateTime.now()),
      'patientid': this.patientid,
      'percentage': this.percentage.toInt(),
      'isParkinson': this.isParkinson,
      'executationid': this.executationid,
    };
  }
}
