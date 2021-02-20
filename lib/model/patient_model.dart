import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkinson_de_bolso/config/route_config.dart';
import 'package:parkinson_de_bolso/constant/app_constant.dart';
import 'package:parkinson_de_bolso/model/patient_classification_model.dart';
import 'package:parkinson_de_bolso/util/string_util.dart';
import 'package:parkinson_de_bolso/widget/custom_circle_avatar.dart';
import 'package:parkinson_de_bolso/widget/custom_list_search.dart';

class PatientModel with StringUtil implements SearchData {
  String id;
  String fullname;
  DateTime birthdate;
  DateTime diagnosis;
  String weight;
  String height;
  File image;
  String imageUrl;
  List<PatientClassificationModel> classifications;
  String userid;

  PatientModel({this.id, this.birthdate, this.diagnosis, this.weight, this.height, this.fullname, this.image, this.classifications, this.userid, this.imageUrl});

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      fullname: json['fullname'],
      birthdate: DateTime.parse(json['birthdate']),
      diagnosis: DateTime.parse(json['diagnosis']),
      weight: json['weight'],
      height: json['height'],
      imageUrl: json['image'],
      userid: json['userid']
    );
  }
  
  Map toJson(bool create) {
    return {
      if(!create)
        'id': this.id,
      'fullname': this.capitalize(this.fullname),
      'birthdate': DateFormat('yyyy-MM-dd').format(this.birthdate),
      'diagnosis': DateFormat('yyyy-MM-dd').format(this.diagnosis),
      'weight': this.weight.toString(),
      'height': this.height.toString(),
      'userid': RouteHandler.loggedInUser.id,
      'image': this.getImage()
    };
  }

  dynamic getImage() {
    if (this.image != null) {
      return {
        'data': base64Encode(this.image.readAsBytesSync()),
        'filename': this.image.path.split('/').last
      };
    } 
    
    if (this.imageUrl != null) {
      return this.imageUrl;
    }

    return null;
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
            ),
            Text(this.fullname.length > 25 ? this.abbreviate(this.fullname) : this.fullname, 
              style: TextStyle(
                color: primaryColor,
                fontSize: 18.0,
                letterSpacing: 1.0
              ),
            ),
            SizedBox()
          ],
        )
      ),
    );
  }

  @override
  String searchText() {
    return this.fullname;
  }

  
  PatientModel clone() => PatientModel(
    id: this.id, 
    fullname: this.fullname,
    birthdate: this.birthdate, 
    diagnosis: this.diagnosis, 
    weight: this.weight, 
    height: this.height, 
    image: this.image, 
    classifications: this.classifications, 
    userid: this.userid, 
    imageUrl: this.imageUrl
  );
}