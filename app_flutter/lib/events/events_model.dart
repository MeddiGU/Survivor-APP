import 'dart:ffi';

class EventDTO {
  final int id;
  final String name;
  final DateTime date;
  final int max_participants;
  final Float location_x;
  final Float location_y;
  final String type;
  final int employee_id;
  final String location_name;

  EventDTO({
    required this.id,
    required this.name,
    required this.date,
    required this.max_participants,
    required this.location_x,
    required this.location_y,
    required this.type,
    required this.employee_id,
    required this.location_name,
  });

  factory EventDTO.fromJson(Map<String, dynamic> json) {
    return EventDTO(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      max_participants: json['max_participants'],
      location_x: json['location_x'],
      location_y: json['location_y'],
      type: json['type'],
      employee_id: json['employee_id'],
      location_name: json['location_name'],
    );
  }
}