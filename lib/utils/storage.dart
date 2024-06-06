import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

const Map<String, String> secureKeys = {
  "endpoint": "%verderamen_endpoint%",
  "username": "%verderamen_username%",
  "password": "%verderamen_password%",
};

Future<String?> getSecureKey(String key) async {
  if (secureKeys[key] == null) {
    throw Exception('Invalid key $key');
  }

  String? value = await _storage.read(key: secureKeys[key]!);
  return value;
}

setSecureKey(String key, String value) async {
  if (secureKeys[key] == null) {
    throw Exception('Invalid key $key');
  }

  await _storage.write(key: secureKeys[key]!, value: value);
  return value;
}

writeSecureKey() {}
