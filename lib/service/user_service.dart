import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/constant/http_constant.dart';
import 'package:parkinson_de_bolso/model/user_model.dart';

class UserService {
  UserService._privateConstructor();
  static final UserService instance = UserService._privateConstructor();
  static final Codec<String, String> toBase64 = utf8.fuse(base64);
  static final String apiAuthHost = '$api_host/authentication';
  static final String apiUserHost = '$api_host/user';

  Future<Map> authenticate(String email, String password) async {
    final String basicAuthenticate = 'Basic ' + UserService.toBase64.encode('$email:$password');
    final http.Response response = await http.get(UserService.apiAuthHost, headers: {
      'authorization': basicAuthenticate
    });
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  Future<UserModel> create(UserModel user) async {
    final http.Response response = await http.post(UserService.apiUserHost, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode(user.toJson(true)));

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<bool> emailExists(String email) async{
    if (email.length > 10) {
      String encryptedEmail = UserService.toBase64.encode(email);
      final http.Response response = await http.get(UserService.apiUserHost + '/$encryptedEmail');
      if (response.statusCode == 200) {
        List content = jsonDecode(response.body)['response'];
        return content != null && content.length > 0;
      }
    }
    return false;
  }
}