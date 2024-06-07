import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:verderamen_mobile/utils/alice.dart';
import 'package:verderamen_mobile/utils/logger.dart';

Future<Map> getTelemetries({
  required String endpoint,
  required String username,
  required String password,
}) async {
  var client = http.Client();
  try {
    final Uri uri = Uri.parse(endpoint).replace(path: '/telemetries/');
    final String authHeader =
        'Basic ${base64.encode(utf8.encode("$username:$password"))}';
    logger.d(uri);
    logger.d(authHeader);
    var response = await client.get(uri, headers: {
      HttpHeaders.authorizationHeader: authHeader,
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    alice.onHttpResponse(response);
    if (response.statusCode != 200) {
      throw Exception('Invalid statusCode ${response.statusCode}!');
    }
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  } finally {
    client.close();
  }
}
