import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GoogleTranslateService {
  static const String _apiKey = 'AIzaSyCfJ679-hZ1NskronNmXmhfYPgFqzKApyg';

  static bool get isConfigured => _apiKey.trim().isNotEmpty;

  static Future<String?> translate({
    required String text,
    required String from,
    required String to,
  }) async {
    if (!isConfigured) {
      debugPrint('⚠ GoogleTranslateService: API key missing.');
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
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final translations = data['data']['translations'] as List<dynamic>;

        if (translations.isNotEmpty) {
          return translations.first['translatedText'] as String?;
        }
      } else {
        debugPrint(
          '❌ GoogleTranslateService error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('❌ GoogleTranslateService exception: $e');
    }

    return null;
  }
}
