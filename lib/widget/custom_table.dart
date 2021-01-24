import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/model/serelization_data_model.dart';
import 'package:parkinson_de_bolso/widget/custom_table_row.dart';

class CustomTable extends StatefulWidget {
  final Color borderColor;
  final List<SerelizationDataModel> data;
  final List<String> titles;
  
  CustomTable({@required this.borderColor, @required this.data, @required this.titles});

  @override
  _CustomTableState createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  List<TableRow> _data;

  void initState() {
    super.initState();
    this._data = <TableRow>[
      CustomTableRow(
        padding: EdgeInsets.all(5),
        values: this.widget.titles,
        isTitle: true
      ).build()
    ];
    
    if (this.widget.data != null)
      this._data.addAll(this.widget.data.map((e) => e.createRow()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          color: this.widget.borderColor,
          style: BorderStyle.solid,
          width: 1.0
        ),
        verticalInside: BorderSide(
          color: this.widget.borderColor,
          style: BorderStyle.solid,
          width: 1.0
        ),
      ),
      children: this._data,
    );
  }

}