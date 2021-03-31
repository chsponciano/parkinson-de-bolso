import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:parkinson_de_bolso/service/aws_cognito_service.dart';
import 'package:http/http.dart' as http;

class NotifyService {
  NotifyService._privateConstructor();
  static final NotifyService instance = NotifyService._privateConstructor();
  final AwsCognitoService awsCognitoService = AwsCognitoService.instance;
  static final String path = '/api/comment';

  void sendComment(String comment) async {
    final SigV4Request signedRequest = this
        .awsCognitoService
        .getSigV4Request('POST', path, body: {'comment': comment});

    await http.post(signedRequest.url,
        headers: signedRequest.headers, body: signedRequest.body);
  }
}
