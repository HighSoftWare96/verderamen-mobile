import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

Future<Map> getTelemetries({
  required String endpoint,
  required String username,
  required String password,
}) async {
  var client = http.Client();
  try {
    final Uri uri = Uri.parse(endpoint).replace(path: '/telemetries');
    Logger(level: Level.debug).d(uri);
    var response = await client.get(uri, headers: {
      "Authorization": base64.encode(utf8.encode("$username:$password"))
    }).timeout(
      const Duration(milliseconds: 1000)
    );
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  } finally {
    client.close();
  }
}
