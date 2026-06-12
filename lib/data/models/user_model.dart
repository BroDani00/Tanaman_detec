// lib/data/models/user_model.dart
class UserModel {
  final int? id;
  final String username;
  final String password;
  final String fullName;
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'full_name': fullName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      fullName: map['full_name'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? password,
    String? fullName,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
