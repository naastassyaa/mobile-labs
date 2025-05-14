import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:test_project/storage/user_data_storage.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final UserDataStorage _storage;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  RegisterCubit({
    required UserDataStorage storage,
    Connectivity? connectivity,
  })  : _storage = storage,
        _connectivity = connectivity ?? Connectivity(),
        super(const RegisterState());

  void init() {
    _checkLoginStatus();
    _connectivitySub =
        _connectivity.onConnectivityChanged.listen((results) {
          final ConnectivityResult status = results.first;
          final bool hasConn = status != ConnectivityResult.none;
          if (hasConn != state.hasConnection) {
            emit(state.copyWith(hasConnection: hasConn));
          }
        });
  }

  Future<void> _checkLoginStatus() async {
    final bool loggedIn = await _storage.isLoggedIn();
    if (loggedIn) {
      emit(state.copyWith(alreadyLoggedIn: true));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      await _storage.saveUser(
        email: email,
        password: password,
        name: name,
        isLoggedIn: true,
      );
      emit(state.copyWith(isSubmitting: false, registrationSuccess: true));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Registration error: \$e',
      ),);
    }
  }

  @override
  Future<void> close() {
    _connectivitySub?.cancel();
    return super.close();
  }
}
