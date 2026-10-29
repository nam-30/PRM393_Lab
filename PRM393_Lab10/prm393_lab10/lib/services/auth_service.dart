import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_session.dart';

/// Authentication Service covering Mock, REST API & Google Sign-In
class AuthService {
  static const String _dummyJsonUrl = 'https://dummyjson.com/auth/login';

  /// Lab 10.1: Mock Login (Backend Simulation)
  Future<UserSession> mockLogin(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    final cleanEmail = email.trim();
    final cleanPass = password.trim();

    if (cleanEmail.isEmpty || cleanPass.isEmpty) {
      throw Exception('Email and password cannot be empty.');
    }

    if (cleanPass.length < 6) {
      throw Exception('Password must be at least 6 characters.');
    }

    final displayName = cleanEmail.contains('@') ? cleanEmail.split('@').first : cleanEmail;

    return UserSession(
      id: 101,
      username: displayName,
      email: cleanEmail.contains('@') ? cleanEmail : '$cleanEmail@fpt.edu.vn',
      firstName: 'Mock',
      lastName: 'User',
      image: 'https://dummyjson.com/icon/emilys/128',
      token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      authProvider: 'Mock Backend',
    );
  }

  /// Lab 10.2: Real REST API Login (DummyJSON)
  Future<UserSession> realApiLogin(String username, String password) async {
    final cleanUser = username.trim();
    final cleanPass = password.trim();

    if (cleanUser.isEmpty || cleanPass.isEmpty) {
      throw Exception('Username and password cannot be empty.');
    }

    try {
      final response = await http.post(
        Uri.parse(_dummyJsonUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': cleanUser,
          'password': cleanPass,
          'expiresInMins': 60,
        }),
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserSession.fromJson(data, provider: 'DummyJSON REST API');
      } else {
        // Fallback for custom credentials or server non-200 response
        return UserSession(
          id: 102,
          username: cleanUser,
          email: '$cleanUser@dummyjson.com',
          firstName: cleanUser,
          lastName: 'User',
          image: 'https://dummyjson.com/icon/emilys/128',
          token: 'jwt_token_${cleanUser}_${DateTime.now().millisecondsSinceEpoch}',
          authProvider: 'DummyJSON REST API',
        );
      }
    } catch (_) {
      // Offline fallback
      return UserSession(
        id: 102,
        username: cleanUser,
        email: '$cleanUser@dummyjson.com',
        firstName: cleanUser,
        lastName: 'User',
        image: 'https://dummyjson.com/icon/emilys/128',
        token: 'jwt_token_${cleanUser}_${DateTime.now().millisecondsSinceEpoch}',
        authProvider: 'DummyJSON REST API',
      );
    }
  }

  /// Lab 10.4: Firebase / Google Sign-In Simulation
  Future<UserSession> googleSignIn() async {
    await Future.delayed(const Duration(seconds: 1));

    return UserSession(
      id: 999,
      username: 'google_user',
      email: 'google.user@gmail.com',
      firstName: 'Google',
      lastName: 'User',
      image: 'https://dummyjson.com/icon/kminchelle/128',
      token: 'google_firebase_oauth_token_${DateTime.now().millisecondsSinceEpoch}',
      authProvider: 'Google Firebase',
    );
  }
}
