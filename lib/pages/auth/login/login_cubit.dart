import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/storage/user_data_storage.dart';

part 'login_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserDataStorage _storage;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  AuthCubit({
    required UserDataStorage storage,
    Connectivity? connectivity,
  })  : _storage = storage,
        _connectivity = connectivity ?? Connectivity(),
        super(const AuthState());

  void init() {
    _connectivitySub =
        _connectivity.onConnectivityChanged.listen((results) {
          final ConnectivityResult status = results.first;
          _onConnectivityChanged(status);
        });
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _onConnectivityChanged(result as ConnectivityResult);
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    final bool hasConn = result != ConnectivityResult.none;
    if (hasConn != state.hasConnection) {
      emit(state.copyWith(hasConnection: hasConn));
    }
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true));
    try {
      final userData = await _storage.getUser(email);
      if (userData == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'User not found',
        ),);
        return;
      }
      if (userData['password'] != password) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Incorrect password',
        ),);
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentUserEmail', email);
      await _storage.updateLoginStatus(email, true);

      emit(state.copyWith(
        isLoading: false,
        loginSuccess: true,
      ),);
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Login error: \$e',
      ),);
    }
  }

  @override
  Future<void> close() {
    _connectivitySub?.cancel();
    return super.close();
  }
}
