import 'dart:convert';

/// UserSession model representing an authenticated user session
class UserSession {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;
  final String token;
  final String authProvider; // 'Mock Backend', 'DummyJSON REST API', 'Google Firebase'

  UserSession({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.token,
    required this.authProvider,
  });

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isNotEmpty ? name : username;
  }

  factory UserSession.fromJson(Map<String, dynamic> json, {String provider = 'DummyJSON REST API'}) {
    return UserSession(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      token: json['accessToken']?.toString() ?? json['token']?.toString() ?? '',
      authProvider: json['authProvider']?.toString() ?? provider,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'token': token,
      'authProvider': authProvider,
    };
  }

  String toRawJson() => jsonEncode(toJson());

  factory UserSession.fromRawJson(String str) =>
      UserSession.fromJson(jsonDecode(str));
}
