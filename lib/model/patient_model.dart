import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/patien_classification_model.dart';
import 'package:parkinson_de_bolso/model/search_model.dart';
import 'package:parkinson_de_bolso/widget/custom_circle_avatar.dart';

class PatientModel implements SearchModel {
  String name;
  DateTime birthDate;
  DateTime diagnosis;
  double weight;
  double height;
  String initials;
  File photo;
  List<PatientClassificationModel> classifications;

  PatientModel({this.initials, this.birthDate, this.diagnosis, this.weight, this.height, this.name, this.photo, this.classifications});

  @override
  ListTile getListTile(Function onTap) {
    return ListTile(
      onTap: () => Function.apply(onTap, [this]),
      title: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: secondaryColorDashboardBar,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0)
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomCircleAvatar(
              radius: 20, 
              background: secondaryColor, 
              foreground: ternaryColor,
              image: this.photo,
              initials: this.initials,
            ),
            Text(this.name, 
              style: TextStyle(
                color: primaryColor,
                fontSize: 18.0,
                letterSpacing: 1.0
              ),
            ),
            Row(
              children: [
                IconButton(
                  color: primaryColor,
                  icon: Icon(Icons.more_vert), 
                  onPressed: () => print('menu')
                )
              ],
            )
          ],
        )
      ),
    );
  }

  @override
  String searchText() {
    return this.name;
  }
}