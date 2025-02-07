class CustomerDTO {
  final int id;
  final String email;
  final String name;
  final String surname;
  final DateTime birthDate;
  final String gender;
  final String description;
  final String astrologicalSign;
  final String phoneNumber;
  final String address;
  final int coachId;

  CustomerDTO({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.birthDate,
    required this.gender,
    required this.description,
    required this.astrologicalSign,
    required this.phoneNumber,
    required this.address,
    required this.coachId,
  });

  String get fullName => '$name $surname';

  factory CustomerDTO.fromJson(Map<String, dynamic> json) {
    return CustomerDTO(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'])
          : DateTime.now(),
      gender: json['gender'] ?? '',
      description: json['description'] ?? '',
      astrologicalSign: json['astrological_sign'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'] ?? '',
      coachId: json['coach_id'] ?? 0,
    );
  }
}