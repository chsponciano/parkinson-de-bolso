import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/interface/search.interface.dart';
import 'package:parkinson_de_bolso/model/patientClassification.model.dart';
import 'package:parkinson_de_bolso/util/string.util.dart';

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

  PatientModel(
      {this.id,
      this.birthdate,
      this.diagnosis,
      this.weight,
      this.height,
      this.fullname,
      this.image,
      this.classifications,
      this.userid,
      this.imageUrl});

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
        id: json['id'],
        fullname: json['fullname'],
        birthdate: DateTime.parse(json['birthdate']),
        diagnosis: DateTime.parse(json['diagnosis']),
        weight: json['weight'],
        height: json['height'],
        imageUrl: json['image'],
        userid: json['userid']);
  }

  Map toJson(bool create) {
    return {
      if (!create) 'id': this.id,
      'fullname': this.capitalize(this.fullname),
      'birthdate': DateFormat('yyyy-MM-dd').format(this.birthdate),
      'diagnosis': DateFormat('yyyy-MM-dd').format(this.diagnosis),
      'weight': this.weight.toString(),
      'height': this.height.toString(),
      'userid': AppConfig.instance.loggedInUser.id,
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
      imageUrl: this.imageUrl);
}
