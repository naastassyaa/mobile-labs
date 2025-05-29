part of 'login_cubit.dart';

@immutable
class LoginState {
  final bool isLoading;
  final bool hasConnection;
  final bool loginSuccess;
  final String? errorMessage;

  const LoginState({
    this.isLoading = false,
    this.hasConnection = true,
    this.loginSuccess = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? hasConnection,
    bool? loginSuccess,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      hasConnection: hasConnection ?? this.hasConnection,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
