import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_session.dart';

/// Service to handle local session persistence (Lab 10.3)
class SessionService {
  static const String _keyUserSession = 'user_session';
  static const String _keyAuthToken = 'auth_token';

  /// Save session and token to SharedPreferences
  Future<bool> saveSession(UserSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAuthToken, session.token);
    return await prefs.setString(_keyUserSession, session.toRawJson());
  }

  /// Retrieve stored user session
  Future<UserSession?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionStr = prefs.getString(_keyUserSession);
    if (sessionStr != null && sessionStr.isNotEmpty) {
      try {
        return UserSession.fromRawJson(sessionStr);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyAuthToken);
    return token != null && token.isNotEmpty;
  }

  /// Clear session and token on logout
  Future<bool> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAuthToken);
    return await prefs.remove(_keyUserSession);
  }
}
