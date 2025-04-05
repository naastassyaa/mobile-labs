import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/storage/user_data_storage.dart';

class Preferences implements UserDataStorage {
  static Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<void> saveUser({
    required String email,
    required String password,
    required String name,
    required bool isLoggedIn,
    String? surname,
    String? dob,
    String? phone,
    String? gender,
  }) async {
    final prefs = await _getPreferences();

    final Map<String, dynamic> userData = {
      'email': email,
      'password': password,
      'name': name,
      'surname': surname,
      'dob': dob,
      'phone': phone,
      'gender': gender,
      'isLoggedIn': isLoggedIn,
    };

    await prefs.setString(email, jsonEncode(userData));
    await prefs.setString('currentUserEmail', email);
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await _getPreferences();
    final email = prefs.getString('currentUserEmail');
    if (email == null) return null;

    final userData = prefs.getString(email);
    if (userData == null) return null;

    return jsonDecode(userData) as Map<String, dynamic>;
  }

  @override
  Future<void> logoutUser() async {
    final prefs = await _getPreferences();
    final email = prefs.getString('currentUserEmail');
    if (email == null) return;

    final userData = prefs.getString(email);
    if (userData == null) return;

    final userMap = jsonDecode(userData);
    userMap['isLoggedIn'] = false;

    await prefs.setString(email, jsonEncode(userMap));
    await prefs.remove('currentUserEmail');
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null && user['isLoggedIn'] == true;
  }

  @override
  Future<void> updateLoginStatus(String email, bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = await getUser(email);

    if (userData != null) {
      userData['isLoggedIn'] = isLoggedIn;
      await prefs.setString(email, jsonEncode(userData));
    }
  }

  @override
  Future<Map<String, dynamic>?> getUser(String email) async {
    final prefs = await _getPreferences();
    final String? userData = prefs.getString(email);

    if (userData != null) {
      final Map<String, dynamic> userMap = jsonDecode(userData)
      as Map<String, dynamic>;
      return userMap;
    }
    return null;
  }

  @override
  Future<String?> getFirstName() async {
    final user = await getCurrentUser();
    if (user != null && user['name'] != null) {
      return user['name'].toString();
    }
    return null;
  }

  @override
  Future<String?> getLastName() async {
    final user = await getCurrentUser();
    if (user != null && user['surname'] != null) {
      return user['surname'].toString();
    }
    return null;
  }
}
