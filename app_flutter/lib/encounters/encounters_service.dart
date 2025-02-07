import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_flutter/config_service.dart';
import 'encounters_model.dart';

class EncountersService {
  final String baseUrl = ConfigService.get('API_BASE_URL');

  Future<List<EncountersDto>> getEncounters() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/encounters'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['message'] == 'success') {
          final List<dynamic> encountersData = responseData['data'];
          return encountersData.map((data) => EncountersDto.fromJson(data)).toList();
        }
      }
      throw Exception('Failed to load encounters');
    } catch (e) {
      throw Exception('Failed to load encounters: $e');
    }
  }

}