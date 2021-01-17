import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/model/search_model.dart';

class PatientModel implements SearchModel {
  final String name;

  PatientModel(this.name);

  @override
  ListTile getListTile() {
    return ListTile(title: Text('${this.name}'));
  }

  @override
  String searchText() {
    return this.name;
  }
}