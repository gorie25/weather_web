class EmailSubscription {
  final String email;

  final DateTime createdAt;
  final String? cityName;

  EmailSubscription({
    required this.email,
    required this.createdAt,
    this.cityName,
  });

  factory EmailSubscription.fromJson(Map<String, dynamic> json) {
    return EmailSubscription(
      email: json['email'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      cityName: json['cityName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'cityName': cityName,
    };
  }
}
