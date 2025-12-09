import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_keys.dart';

class GoogleTranslateService {
 
  static String get _apiKey => ApiKeys.googleTranslateApiKey;



  static bool get isConfigured => _apiKey.isNotEmpty;

  static Future<String?> translate({
    required String text,
    required String from,
    required String to,
  }) async {
    if (!isConfigured) {
      debugPrint(
        'GoogleTranslateService: No API key found — skipping API translation.',
      );
      return null;
    }

    final url = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?key=$_apiKey',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': text,
          'source': from,
          'target': to,
          'format': 'text',
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final translations = json['data']['translations'] as List<dynamic>;

        if (translations.isNotEmpty) {
          return translations.first['translatedText'] as String?;
        }
      } else {
        debugPrint(
          "GoogleTranslateService ERROR ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("GoogleTranslateService EXCEPTION: $e");
    }

    return null;
  }
}
