import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/storage/user_data_storage.dart';

class PreferencesStorage implements UserDataStorage {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
    final prefs = await _prefs;
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'name': name,
      'surname': surname,
      'dob': dob,
      'phone': phone,
      'gender': gender,
      'isLoggedIn': isLoggedIn,
    };
    await prefs.setString(email, jsonEncode(data));
    await prefs.setString('currentUserEmail', email);
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await _prefs;
    final email = prefs.getString('currentUserEmail');
    if (email == null) return null;
    final json = prefs.getString(email);
    return json != null ? jsonDecode(json) as Map<String, dynamic> : null;
  }

  @override
  Future<void> logoutUser() async {
    final prefs = await _prefs;
    final email = prefs.getString('currentUserEmail');
    if (email == null) return;
    final userJson = prefs.getString(email);
    if (userJson == null) return;
    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    userMap['isLoggedIn'] = false;
    await prefs.setString(email, jsonEncode(userMap));
    await prefs.remove('currentUserEmail');
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user?['isLoggedIn'] == true;
  }

  @override
  Future<void> updateLoginStatus(String email, bool isLoggedIn) async {
    final prefs = await _prefs;
    final json = prefs.getString(email);
    if (json == null) return;
    final userMap = jsonDecode(json) as Map<String, dynamic>;
    userMap['isLoggedIn'] = isLoggedIn;
    await prefs.setString(email, jsonEncode(userMap));
  }

  @override
  Future<Map<String, dynamic>?> getUser(String email) async {
    final prefs = await _prefs;
    final json = prefs.getString(email);
    return json != null ? jsonDecode(json) as Map<String, dynamic> : null;
  }

  @override
  Future<String?> getFirstName() async {
    final user = await getCurrentUser();
    return user?['name']?.toString();
  }

  @override
  Future<String?> getLastName() async {
    final user = await getCurrentUser();
    return user?['surname']?.toString();
  }
}
