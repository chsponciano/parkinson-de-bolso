class ReportModel {
  String id;
  String name;
  int active;
  String expressionAttributeValues;
  String filterExpression;
  int icon;
  String projectionExpression;
  String tableName;
  String titles;

  ReportModel({
    this.id,
    this.name,
    this.active,
    this.expressionAttributeValues,
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
      expressionAttributeValues: json['expressionAttributeValues'],
      filterExpression: json['filterExpression'],
      icon: json['icon'],
      projectionExpression: json['projectionExpression'],
      tableName: json['tableName'],
      titles: json['titles'],
    );
  }
}
