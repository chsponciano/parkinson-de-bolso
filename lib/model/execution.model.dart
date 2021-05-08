class ExecutionModel {
  String id;
  int index;
  String image;
  int isParkinson;
  double percentage;

  ExecutionModel({
    this.id,
    this.index,
    this.percentage,
    this.image,
    this.isParkinson,
  });

  factory ExecutionModel.fromJson(Map json) {
    return ExecutionModel(
      id: json['_id'],
      index: int.parse(json['index'].toString()),
      percentage: double.parse(json['percentage'].toString()),
      image: json['image'],
      isParkinson: json['isParkinson'],
    );
  }

  Map toJson(bool create) {
    return {
      if (!create) '_id': this.id,
      'index': this.index,
      'percentage': this.percentage,
      'image': this.image,
      'isParkinson': this.isParkinson,
    };
  }
}
