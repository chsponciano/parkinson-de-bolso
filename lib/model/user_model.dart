class UserModel{
  String id;
  String name;
  String email;
  String password;

  UserModel({this.id, this.name, this.email, this.password});

  factory UserModel.fromJson(Map json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
  
  Map toJson(bool create, bool update) {
    return {
      if(!create && !update)
        '_id': this.id,
      'name': this.name,
      'email': this.email,
      'password': this.password,
    };
  }
}