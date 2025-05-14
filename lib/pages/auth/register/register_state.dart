part of 'register_cubit.dart';

@immutable
class RegisterState {
  final bool alreadyLoggedIn;
  final bool hasConnection;
  final bool isSubmitting;
  final bool registrationSuccess;
  final String? errorMessage;

  const RegisterState({
    this.alreadyLoggedIn = false,
    this.hasConnection = true,
    this.isSubmitting = false,
    this.registrationSuccess = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? alreadyLoggedIn,
    bool? hasConnection,
    bool? isSubmitting,
    bool? registrationSuccess,
    String? errorMessage,
  }) {
    return RegisterState(
      alreadyLoggedIn: alreadyLoggedIn ?? this.alreadyLoggedIn,
      hasConnection: hasConnection ?? this.hasConnection,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      registrationSuccess: registrationSuccess ?? this.registrationSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
