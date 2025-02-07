class EncountersDto {
  final int id;
  final int customer_id;
  final DateTime date;
  final int rating;
  final String comment;
  final String source;

  EncountersDto({
    required this.id,
    required this.customer_id,
    required this.date,
    required this.rating,
    required this.comment,
    required this.source,
  });

  factory EncountersDto.fromJson(Map<String, dynamic> json) {
    return EncountersDto(
      id: json['id'] ?? 0,
      customer_id: json['customer_id'] ?? 0,
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      source: json['source'] ?? '',
    );
  }
}