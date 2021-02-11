class ActiveClassificationModel{
  String id;
  String patientid;
  String publicid;

  ActiveClassificationModel({this.id, this.patientid, this.publicid});

  factory ActiveClassificationModel.fromJson(Map json) {
    return ActiveClassificationModel(
      id: json['_id'],
      patientid: json['patientid'],
      publicid: json['publicid']
    );
  }
  
  Map toJson(bool create) {
    return {
      if(!create)
        '_id': this.id,
        'publicid': this.publicid,
      'patientid': this.patientid,
    };
  }
}