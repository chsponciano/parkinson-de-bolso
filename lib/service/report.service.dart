import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:parkinson_de_bolso/adapter/aws.adpater.dart';
import 'package:http/http.dart' as http;
import 'package:parkinson_de_bolso/model/report.model.dart';

class ReportService {
  ReportService._privateConstructor();
  static final ReportService instance = ReportService._privateConstructor();
  final AwsAdapter awsAdapter = AwsAdapter.instance;
  static final String path = '/api/report';

  Future<List<ReportModel>> getAll() async {
    final SigV4Request signedRequest = this.awsAdapter.getSigV4Request(
          'GET',
          path,
        );

    final http.Response response = await http.get(
      signedRequest.url,
      headers: signedRequest.headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => ReportModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load report');
    }
  }
}
