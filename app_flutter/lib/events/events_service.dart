import 'package:app_flutter/config_service.dart';
import 'package:app_flutter/events/events_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventsService {
  final baseUrl = ConfigService.get('API_BASE_URL');

  Future<List<EventDTO>> fetchEvents() async {
    final apiUrl = "$baseUrl/api/events";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      if (jsonData.containsKey('data')) {
        List<dynamic> eventsList = jsonData['data'];
        return eventsList.map((item) => EventDTO.fromJson(item)).toList();
      } else {
        throw Exception("La réponse ne contient pas de données d'événements");
      }
    } else {
      throw Exception("Échec du chargement des événements");
    }
  }
}