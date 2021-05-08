import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/modules/dashboard/patient/table/table.row.patient.dah.dart';
import 'package:parkinson_de_bolso/util/serelization.util.dart';

class TablePatient extends StatefulWidget {
  final Color borderColor;
  final List<SerelizationDataUtil> data;
  final List<String> titles;

  TablePatient({
    @required this.borderColor,
    @required this.data,
    @required this.titles,
  });

  @override
  _TablePatientState createState() => _TablePatientState();
}

class _TablePatientState extends State<TablePatient> {
  List<TableRow> _data;

  void initializeData() {
    this._data = <TableRow>[
      TableRowPatientDash(
              padding: EdgeInsets.all(5),
              values: this.widget.titles,
              isTitle: true)
          .create(context)
    ];

    if (this.widget.data != null)
      this
          ._data
          .addAll(this.widget.data.map((e) => e.createRow(context)).toList());
  }

  @override
  Widget build(BuildContext context) {
    this.initializeData();

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        border: TableBorder(
          horizontalInside: BorderSide(
            color: Colors.grey[300],
            style: BorderStyle.solid,
            width: 1.0,
          ),
        ),
        children: this._data,
      ),
    );
  }
}
