part of 'profile_cubit.dart';

@immutable
class ProfileState {
  final String? firstName;
  final String? lastName;
  final bool logoutSuccess;
  final String? errorMessage;

  const ProfileState({
    this.firstName,
    this.lastName,
    this.logoutSuccess = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    String? firstName,
    String? lastName,
    bool? logoutSuccess,
    String? errorMessage,
  }) {
    return ProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      logoutSuccess: logoutSuccess ?? this.logoutSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
