part of 'edit_profile_cubit.dart';

@immutable
class EditProfileState {
  final bool loaded;
  final bool hasConnection;
  final bool isSubmitting;
  final bool saveSuccess;
  final String? errorMessage;

  final String? name;
  final String? surname;
  final String? dob;
  final String? email;
  final String? phone;
  final String? gender;
  final String? password;

  const EditProfileState({
    this.loaded = false,
    this.hasConnection = true,
    this.isSubmitting = false,
    this.saveSuccess = false,
    this.errorMessage,
    this.name,
    this.surname,
    this.dob,
    this.email,
    this.phone,
    this.gender,
    this.password,
  });

  EditProfileState copyWith({
    bool? loaded,
    bool? hasConnection,
    bool? isSubmitting,
    bool? saveSuccess,
    String? errorMessage,
    String? name,
    String? surname,
    String? dob,
    String? email,
    String? phone,
    String? gender,
    String? password,
  }) {
    return EditProfileState(
      loaded: loaded ?? this.loaded,
      hasConnection: hasConnection ?? this.hasConnection,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      password: password ?? this.password,
    );
  }
}
