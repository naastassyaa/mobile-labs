import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/components/general/no_internet_connection.dart';
import 'package:test_project/pages/auth/login/login_cubit.dart';
import 'package:test_project/pages/auth/login/login_form.dart';
import 'package:test_project/storage/user_data_storage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(
          storage: context.read<UserDataStorage>(),)..init(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();
  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryAutoLogin());
  }

  Future<void> _tryAutoLogin() async {
    final storage = context.read<UserDataStorage>();
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('currentUserEmail');
    if (email == null) return;
    final userData = await storage.getUser(email);
    if (userData == null) return;
    await storage.updateLoginStatus(email, true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => prev.hasConnection && !curr.hasConnection,
      listener: (_, __) {
        showDialog<void>(
          context: context,
          builder: (_) => const NoInternetConnectionDialog(),
        );
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.loginSuccess) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: LoginForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    isLoading: state.isLoading,
                    onLogin: (email, pass) =>
                        context.read<AuthCubit>().login(email, pass),
                    onForgotPassword: () =>
                        Navigator.pushNamed(context, '/'),
                    onRegister: () =>
                        Navigator.pushNamed(context, '/register'),
                  ),
                ),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}
