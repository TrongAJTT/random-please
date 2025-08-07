class Donor {
  final String userName;
  final String avatar;
  final String comment;
  final DateTime date;

  const Donor({
    required this.userName,
    required this.avatar,
    required this.comment,
    required this.date,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      userName: json['userName'] ?? '',
      avatar: json['avatar'] ?? '',
      comment: json['comment'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'avatar': avatar,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}
