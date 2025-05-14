import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:test_project/storage/user_data_storage.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UserDataStorage _storage;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  EditProfileCubit({
    required UserDataStorage storage,
    Connectivity? connectivity,
  })  : _storage = storage,
        _connectivity = connectivity ?? Connectivity(),
        super(const EditProfileState());

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

  Future<void> _loadProfile() async {
    try {
      final data = await _storage.getCurrentUser();
      if (data != null) {
        emit(state.copyWith(
          loaded: true,
          name: data['name']?.toString(),
          surname: data['surname']?.toString(),
          dob: data['dob']?.toString(),
          email: data['email']?.toString(),
          phone: data['phone']?.toString(),
          gender: data['gender']?.toString(),
          password: data['password']?.toString(),
        ),);
      }
    } catch (_) {}
  }

  Future<void> saveProfile() async {
    emit(state.copyWith(isSubmitting: true));
    try {
      await _storage.saveUser(
        email: state.email ?? '',
        password: state.password ?? '',
        name: state.name ?? '',
        isLoggedIn: true,
        surname: state.surname,
        dob: state.dob,
        phone: state.phone,
        gender: state.gender,
      );
      emit(state.copyWith(isSubmitting: false, saveSuccess: true));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Save error: \$e',
      ),);
    }
  }

  void updateField({
    String? name,
    String? surname,
    String? dob,
    String? email,
    String? phone,
    String? gender,
  }) {
    emit(state.copyWith(
      name: name,
      surname: surname,
      dob: dob,
      email: email,
      phone: phone,
      gender: gender,
    ),);
  }

  @override
  Future<void> close() {
    _connectivitySub?.cancel();
    return super.close();
  }
}
