import 'dart:convert';
import 'package:app_flutter/config_service.dart';
import 'package:http/http.dart' as http;
import 'tips_model.dart';

class TipsService {
  final String baseUrl = ConfigService.get('API_BASE_URL');

  Future<List<TipsDto>> fetchTips() async {
    final String apiUrl = "$baseUrl/api/tips";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Décoder la réponse
      Map<String, dynamic> jsonData = json.decode(response.body);
      // Vérifier si 'data' est présent dans le JSON
      if (jsonData.containsKey('data')) {
        List<dynamic> tipsList = jsonData['data'];  // On récupère la liste dans la clé 'data'
        // Convertir la liste dynamique en une liste d'objets TipsDto
        return tipsList.map((item) => TipsDto.fromJson(item)).toList();
      } else {
        throw Exception("La réponse ne contient pas de données de tips");
      }
    } else {
      throw Exception("Échec du chargement des tips");
    }
  }
}
