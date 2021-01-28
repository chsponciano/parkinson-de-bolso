import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkinson_de_bolso/config/route.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/patien_classification_model.dart';
import 'package:parkinson_de_bolso/model/search_model.dart';
import 'package:parkinson_de_bolso/util/string_util.dart';
import 'package:parkinson_de_bolso/widget/custom_circle_avatar.dart';

class PatientModel implements SearchModel {
  String id;
  String name;
  DateTime birthdate;
  DateTime diagnosis;
  double weight;
  double height;
  String initials;
  File image;
  String imageUrl;
  List<PatientClassificationModel> classifications;
  String userid;

  PatientModel({this.id, this.initials, this.birthdate, this.diagnosis, this.weight, this.height, this.name, this.image, this.classifications, this.userid, this.imageUrl});

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['_id'],
      name: json['name'],
      birthdate: DateTime.parse(json['birthdate']),
      diagnosis: DateTime.parse(json['diagnosis']),
      weight: json['weight'],
      height: json['height'],
      initials: json['initials'],
      imageUrl: json['image'],
      userid: json['userid']
    );
  }
  
  Map toJson(bool create, bool update) {
    return {
      if(!create && !update)
        '_id': this.id,
      'name': this.name,
      'birthdate': DateFormat('yyyy-MM-dd').format(this.birthdate),
      'diagnosis': DateFormat('yyyy-MM-dd').format(this.diagnosis),
      'weight': this.weight,
      'height': this.height,
      'initials': StringUtil.getInitials(this.name),
      'userid': RouteHandler.loggedInUser.id,
      if (this.image != null)
        'image': {
          'data': base64Encode(this.image.readAsBytesSync()),
          'filename': this.image.path.split('/').last
        }
      
    };
  }

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
              imagePath: this.imageUrl,
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