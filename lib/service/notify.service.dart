import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:parkinson_de_bolso/adapter/aws.adpater.dart';
import 'package:parkinson_de_bolso/config/app.config.dart';
import 'package:parkinson_de_bolso/model/receivedNotification.model.dart';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/model/user.model.dart';

class NotifyService {
  NotifyService._privateConstructor();
  static final NotifyService instance = NotifyService._privateConstructor();
  final AwsAdapter awsAdapter = AwsAdapter.instance;
  final AppConfig appConfig = AppConfig.instance;
  static final String path = '/api/notification';

  Future<List<ReceivedNotificationModel>> getAll() async {
    final SigV4Request signedRequest =
        this.awsAdapter.getSigV4Request('GET', path);
    final http.Response response = await http.get(
        '${signedRequest.url}/${AppConfig.instance.loggedInUser.id}',
        headers: signedRequest.headers);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => ReceivedNotificationModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<ReceivedNotificationModel> markRead(
      ReceivedNotificationModel notification) async {
    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
          'PUT',
          path,
          body: notification.toJson(true),
        );
    final http.Response response = await http.put(
        '${signedRequest.url}/read/${notification.id}',
        headers: signedRequest.headers,
        body: signedRequest.body);

    if (response.statusCode == 200) {
      return ReceivedNotificationModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to mark read');
    }
  }

  void sendComment(String comment) async {
    String message = 'Usuário: ${this.appConfig.loggedInUser.name}\n';
    message += 'ID: ${this.appConfig.loggedInUser.id}\n';
    message += 'Comentário: $comment';

    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
      'POST',
      '/api/comment',
      body: {'comment': message},
    );

    await http.post(signedRequest.url,
        headers: signedRequest.headers, body: signedRequest.body);
  }
}
