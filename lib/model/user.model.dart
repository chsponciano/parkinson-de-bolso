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
}