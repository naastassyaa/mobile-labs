part of 'login_cubit.dart';

@immutable
class AuthState {
  final bool isLoading;
  final bool hasConnection;
  final bool loginSuccess;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.hasConnection = true,
    this.loginSuccess = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? hasConnection,
    bool? loginSuccess,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      hasConnection: hasConnection ?? this.hasConnection,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
