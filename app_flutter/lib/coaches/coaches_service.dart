import 'package:app_flutter/config_service.dart';
import 'coaches_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CoachesService {
  final String baseUrl = ConfigService.get('API_BASE_URL');

  Future<List<CoachesDTO>> fetchCoaches() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/users'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['message'] == 'success') {
          final List<dynamic> coachesData = responseData['data'];
          return coachesData.map((data) => CoachesDTO.fromJson(data)).toList();
        }
      }
      throw Exception('Failed to load coaches');
    } catch (e) {
      throw Exception('Failed to load coaches: $e');
    }
  }

  Future<CoachesDTO> fetchCoachById(int id) async {
    final String apiUrl = "$baseUrl/api/coaches/$id";
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      if (jsonData.containsKey('data')) {
        return CoachesDTO.fromJson(jsonData['data']);
      } else {
        throw Exception("La réponse ne contient pas de données de coach");
      }
    } else {
      throw Exception("Échec du chargement du coach");
    }
  }
}