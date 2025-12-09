import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_keys.dart';

class TranslateApiService {
  static const String _baseUrl =
      "https://translation.googleapis.com/language/translate/v2";

  
  static Future<String?> translateText({
    required String text,
    required String targetLanguageCode,
    required String sourceLanguageCode,
  }) async {
    try {
      final uri = Uri.parse("$_baseUrl?key=${ApiKeys.googleTranslateApiKey}");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "q": text,
          "source": sourceLanguageCode,
          "target": targetLanguageCode,
          "format": "text",
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        return body["data"]["translations"][0]["translatedText"];
      } else {
        print("❌ GOOGLE API ERROR: ${response.body}");
      }
    } catch (e) {
      print("❌ API Exception: $e");
    }

    return null;
  }
}
