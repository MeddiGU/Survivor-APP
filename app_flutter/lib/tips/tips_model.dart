class TipsDto {
  final int id;
  final String title;
  final String tip;

  TipsDto({
    required this.id,
    required this.title,
    required this.tip,
  });

  factory TipsDto.fromJson(Map<String, dynamic> json) {
    return TipsDto(
      id: json['id'],
      title: json['title'],
      tip: json['tip'],
    );
  }
}