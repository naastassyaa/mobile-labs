import 'package:bloc/bloc.dart';
import 'package:test_project/storage/user_data_storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserDataStorage storage;

  AuthCubit({required this.storage}) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final loggedIn = await storage.isLoggedIn();
    if (loggedIn) {
      final user = await storage.getCurrentUser();
      emit(AuthAuthenticated(user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required String name,
    required bool isLoggedIn,
    String? surname,
    String? dob,
    String? phone,
    String? gender,
  }) async {
    emit(AuthLoading());
    await storage.saveUser(
      email: email,
      password: password,
      name: name,
      isLoggedIn: isLoggedIn,
      surname: surname,
      dob: dob,
      phone: phone,
      gender: gender,
    );
    final user = await storage.getCurrentUser();
    emit(AuthAuthenticated(user!));
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await storage.logoutUser();
    emit(AuthUnauthenticated());
  }
}
