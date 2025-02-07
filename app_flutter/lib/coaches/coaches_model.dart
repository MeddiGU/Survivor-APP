class CoachesDTO {
  final int id;
  final String name;
  final String email;
  final String surname;
  final DateTime birth_date;
  final String gender;
  final String work;

  CoachesDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.surname,
    required this.birth_date,
    required this.gender,
    required this.work,
  });

  factory CoachesDTO.fromJson(Map<String, dynamic> json) {
    return CoachesDTO(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      surname: json['surname'],
      birth_date: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'])
          : DateTime.now(),
      gender: json['gender'],
      work: json['work'],
    );
  }
}