import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class GameDataService {
  static Future<Map<String, dynamic>> loadGameData(Locale locale) async {
    final langCode = locale.languageCode;
    final path = 'assets/lang/${langCode}_game_data.json';

    final String response = await rootBundle.loadString(path);
    final data = await json.decode(response);
    return data;
  }
}
