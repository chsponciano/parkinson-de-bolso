class UserModel{
  String id;
  String name;
  String email;
  String password;
  String publicid;

  UserModel({this.id, this.name, this.email, this.password, this.publicid});

  factory UserModel.fromJson(Map json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      publicid: json['publicid']
    );
  }
  
  Map toJson(bool create) {
    return {
      if(!create)
        '_id': this.id,
        'publicid': this.publicid,
      'name': this.name,
      'email': this.email,
      'password': this.password,
    };
  }
}