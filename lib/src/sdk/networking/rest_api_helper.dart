import 'dart:convert';

import 'package:http/http.dart' show Client, Response;

class RestApiHelper {
  Client client = Client();
  final timeout = 120;

  Future<Response> get(url, {Map<String, String> headers, Map<String, String> body}) async {
    String params = "?";
    body?.forEach((key, value) {
      params += "$key=$value&";
    });
    if (params == "?") {
      params = "";
    }
    url = "$url$params";
    print("GET | $url");

    return client.get(Uri.parse(url), headers: headers).timeout(Duration(seconds: timeout));
  }

  Future<Response> post(
    url, {
    Map<String, String> headers,
    body: dynamic,
  }) async {
    print("POST | $url | $body");
    return client
        .post(Uri.parse(url), headers: headers, body: body, encoding: Encoding.getByName("utf-8"))
        .timeout(Duration(seconds: timeout));
  }

  Future<Response> put(
    url, {
    Map<String, String> headers,
    body: dynamic,
  }) async {
    print("PUT | $url | $body");
    return client
        .put(Uri.parse(url), headers: headers, body: body, encoding: Encoding.getByName("utf-8"))
        .timeout(Duration(seconds: timeout));
  }
}
