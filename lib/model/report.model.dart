import 'package:parkinson_de_bolso/config/app.config.dart';

class ReportModel {
  String id;
  String name;
  int active;
  String filterExpression;
  int icon;
  String projectionExpression;
  String tableName;
  String titles;

  ReportModel({
    this.id,
    this.name,
    this.active,
    this.filterExpression,
    this.icon,
    this.projectionExpression,
    this.tableName,
    this.titles,
  });

  factory ReportModel.fromJson(Map json) {
    return ReportModel(
      id: json['id'],
      name: json['name'],
      active: json['active'],
      filterExpression: json['FilterExpression'],
      icon: json['icon'],
      projectionExpression: json['ProjectionExpression'],
      tableName: json['TableName'],
      titles: json['titles'],
    );
  }

  Map toJson() {
    return {
      'name': this.name,
      'active': this.active,
      'FilterExpression': this.filterExpression,
      'icon': this.icon,
      'ProjectionExpression': this.projectionExpression,
      'TableName': this.tableName,
      'titles': this.titles,
      'userid': AppConfig.instance.loggedInUser.id,
      'additional': {
        'userid': AppConfig.instance.loggedInUser.id,
      }
    };
  }
}
