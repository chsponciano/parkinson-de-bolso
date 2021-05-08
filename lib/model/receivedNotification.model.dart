import 'package:flutter/material.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';

class ReceivedNotificationModel {
  final String id;
  final int notificationid;
  final String title;
  final String body;
  final String payload;
  final String userid;
  final int read;
  final String additional;

  ReceivedNotificationModel({
    this.id,
    @required this.notificationid,
    @required this.title,
    @required this.body,
    @required this.payload,
    this.userid,
    this.read,
    this.additional,
  });

  factory ReceivedNotificationModel.fromJson(Map<String, dynamic> json) {
    return ReceivedNotificationModel(
      id: json['id'],
      notificationid: json['notificationid'],
      title: json['title'],
      body: json['body'],
      payload: json['payload'],
      userid: json['userid'],
      read: json['isread'],
      additional: json['additional'],
    );
  }

  Map toJson(bool create) {
    return {
      if (!create) 'id': this.id,
      'notificationid': this.notificationid,
      'title': this.title,
      'body': this.body,
      'payload': this.payload,
      'userid': AppConfig.instance.loggedInUser.id,
      'isread': this.read,
    };
  }
}
