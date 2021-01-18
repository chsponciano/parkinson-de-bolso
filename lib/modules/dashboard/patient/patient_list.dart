import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/model/search_model.dart';

// ignore: must_be_immutable
class PatientList extends StatelessWidget {
  List<SearchModel> cachedData;

  PatientList({this.cachedData});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: this.cachedData.length,
              itemBuilder: (context, index) => this.cachedData[index].getListTile(),
            )
          )
        ]
      )
    );
  }
}