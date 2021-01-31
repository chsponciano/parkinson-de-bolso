import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/constant/http_constant.dart';
import 'package:parkinson_de_bolso/model/user_model.dart';

class PasswordResetService {
  PasswordResetService._privateConstructor();
  static final PasswordResetService instance = PasswordResetService._privateConstructor();
  static final Codec<String, String> toBase64 = utf8.fuse(base64);
  static final String apiRequestReset = '$api_host/request/reset';
  static final String apiRequestValide = '$api_host/request/valide';
  static final String apiRequestEffectuate = '$api_host/request/effectuate';

  Future<bool> requestReset(String email) async {
    String encryptedEmail = PasswordResetService.toBase64.encode(email);
    final http.Response response = await http.get(PasswordResetService.apiRequestReset + '/$encryptedEmail');
    return (response.statusCode == 200);
  }

  Future<bool> validateCode(String email, String code) async {
    String encryptedEmail = PasswordResetService.toBase64.encode(email);
    final http.Response response = await http.get(PasswordResetService.apiRequestValide + '/$encryptedEmail/$code');
    return (response.statusCode == 200);
  }

  Future<UserModel> effectuate(String email, String password) async {
    final http.Response response = await http.put(PasswordResetService.apiRequestEffectuate,  headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode({
      'email': email,
      'password': password
    }));
    
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body)['response']);
    } else {
      throw Exception('Failed to load user');
    }
  }
}