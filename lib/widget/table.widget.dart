import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/model/tableRow.model.dart';
import 'package:parkinson_de_bolso/util/serelization.util.dart';

class TableWidget extends StatefulWidget {
  final Color borderColor;
  final List<SerelizationDataUtil> data;
  final List<String> titles;

  TableWidget({
    @required this.borderColor,
    @required this.data,
    @required this.titles,
  });

  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  List<TableRow> _data;

  void initializeData() {
    this._data = <TableRow>[
      TableRowModel(
              padding: EdgeInsets.all(5),
              values: this.widget.titles,
              isTitle: true)
          .create()
    ];

    if (this.widget.data != null)
      this._data.addAll(this.widget.data.map((e) => e.createRow()).toList());
  }

  @override
  Widget build(BuildContext context) {
    this.initializeData();

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(
              color: this.widget.borderColor,
              style: BorderStyle.solid,
              width: 1.0),
          verticalInside: BorderSide(
              color: this.widget.borderColor,
              style: BorderStyle.solid,
              width: 1.0),
        ),
        children: this._data,
      ),
    );
  }
}
