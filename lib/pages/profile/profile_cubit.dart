import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/storage/user_data_storage.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserDataStorage _storage;
  final String mcuUrl;

  ProfileCubit({
    required UserDataStorage storage,
    this.mcuUrl = 'http://192.168.1.150',
  })  : _storage = storage,
        super(const ProfileState()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final first = await _storage.getFirstName();
      final last = await _storage.getLastName();
      emit(state.copyWith(
        firstName: first,
        lastName: last,
      ),);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> logout() async {
    await _storage.logoutUser();
    emit(state.copyWith(logoutSuccess: true));
  }

  Future<bool> isControllerConnected() async {
    try {
      final resp = await http.get(Uri.parse('$mcuUrl/status'))
          .timeout(const Duration(seconds: 2));
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
