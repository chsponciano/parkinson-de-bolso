class ExecutionClassificationModel {
  String id;
  int index;
  double percentage;
  String patientid;

  ExecutionClassificationModel({this.id, this.index, this.percentage, this.patientid});

  factory ExecutionClassificationModel.fromJson(Map json) {
    return ExecutionClassificationModel(
      id: json['_id'],
      index: int.parse(json['index'].toString()),
      percentage: double.parse(json['percentage'].toString() + '.0'),
      patientid: json['patientid']
    );
  }
  
  Map toJson(bool create) {
    return {
      if(!create)
        '_id': this.id,
      'index': this.index,
      'percentage': this.percentage,
      'patientid': this.patientid,
    };
  }
}