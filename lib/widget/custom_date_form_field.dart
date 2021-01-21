import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CustomDateFormField extends StatefulWidget {
  final TextEditingController controller;
  String hintText;
  String labelText;

  CustomDateFormField({@required this.controller, @required this.hintText, @required this.labelText}) :
    assert(hintText != null),
    assert(labelText != null),
    assert(controller != null);

  @override
  _CustomDateFormFieldState createState() => _CustomDateFormFieldState();
}

class _CustomDateFormFieldState extends State<CustomDateFormField> {
  
  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now(),
    );

    if (result == null) return;

    setState(() {
      this.widget.controller.text = new DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try{
      return new DateFormat.yMd().parseStrict(input);
    } catch (e) {
      return null;
    }    
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = this.convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () => this._chooseDate(context, this.widget.controller.text),
      controller: this.widget.controller,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today),
        hintText: this.widget.hintText,
        labelText: this.widget.labelText,
      ),
      validator: (val) => this.isValidDob(val) ? null : 'Not a valid date',
    );
  }

}