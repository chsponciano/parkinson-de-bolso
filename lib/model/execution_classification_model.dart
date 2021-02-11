class ExecutionClassificationModel {
  String id;
  int index;
  double percentage;
  String patientid;
  String publicid;

  ExecutionClassificationModel({this.id, this.index, this.percentage, this.patientid, this.publicid});

  factory ExecutionClassificationModel.fromJson(Map json) {
    return ExecutionClassificationModel(
      id: json['_id'],
      index: int.parse(json['index'].toString()),
      percentage: double.parse(json['porcentage'].toString() + '.0'),
      patientid: json['patientid'],
      publicid: json['publicid']
    );
  }
  
  Map toJson(bool create) {
    return {
      if(!create)
        '_id': this.id,
        'publicid': this.publicid,
      'index': this.index,
      'percentage': this.percentage,
      'patientid': this.patientid,
    };
  }
}