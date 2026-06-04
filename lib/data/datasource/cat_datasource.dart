import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cat_model.dart';

class CatDatasource {
  static const String _apiKey =
      'live_kbZFIcbWSGUukkLTau1g90we7ninHZBQAIgzbf5OkDUjxAB7JEBS14mKSDzvSuWk';

  Future<List<CatModel>> getCats({int limit = 20, int page = 0}) async {
    try {
      final uri = Uri.https(
        'api.thecatapi.com',
        '/v1/images/search',
        {
          'limit': limit.toString(),
          'page': page.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'x-api-key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final results = jsonDecode(response.body) as List<dynamic>;
        return results
            .cast<Map<String, dynamic>>()
            .map((json) => CatModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Error al cargar gatos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
