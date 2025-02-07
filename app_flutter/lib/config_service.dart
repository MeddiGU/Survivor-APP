import 'dart:convert';
import 'package:flutter/services.dart';

class ConfigService {
  static Map<String, dynamic>? _config;

  static Future<void> loadConfig() async {
    final String configString = await rootBundle.loadString('assets/config.json');
    _config = json.decode(configString);
  }

  static String get(String key, {String defaultValue = ""}) {
    return _config?[key] ?? defaultValue;
  }
}
