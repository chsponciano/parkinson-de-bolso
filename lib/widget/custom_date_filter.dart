import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/util/datetime_util.dart';

class CustomDateFilter extends StatefulWidget {
  final String label;
  final DateTime date;
  final Function onSet;

  const CustomDateFilter({Key key, this.label, this.date, this.onSet}) : super(key: key);

  @override
  _CustomDateFilterState createState() => _CustomDateFilterState();
}

class _CustomDateFilterState extends State<CustomDateFilter> with DateTimeUtil {
  DateTime _filter;

  @override
  void initState() {
    this._filter = this.widget.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showMonthPicker(
          context: context, 
          initialDate: (this.widget.date != null) ? this.widget.date : DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2200),
        ).then((date) {
          if (date != null) {
            this.setState(() => this._filter = date);
            Function.apply(this.widget.onSet, [date]);
          }
        });
      },
      child: Column(
        children: [
          Text(
            this.widget.label,
            style: TextStyle(
              color: primaryColor
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: primaryColor,
              ),
              SizedBox(width: 10),
              Text(
                this.getMonthYear(this._filter.millisecondsSinceEpoch, true),
                style: TextStyle(
                  color: primaryColor
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}