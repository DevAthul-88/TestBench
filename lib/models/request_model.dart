import 'package:http/http.dart' as http;

class RequestModel {
  String url;
  String method;
  Map<String, String> headers;
  String? body;
  http.Response? response;

  RequestModel({
    required this.url,
    required this.method,
    this.headers = const {},
    this.body,
    this.response,
  });
}