abstract class UserDataStorage {
  Future<void> saveUser({
    required String email,
    required String password,
    required String name,
    required bool isLoggedIn,
    String? surname,
    String? dob,
    String? phone,
    String? gender,
  });

  Future<Map<String, dynamic>?> getCurrentUser();

  Future<void> logoutUser();

  Future<bool> isLoggedIn();

  Future<void> updateLoginStatus(String email, bool isLoggedIn);

  Future<Map<String, dynamic>?> getUser(String email);

  Future<String?> getFirstName();

  Future<String?> getLastName();
}
