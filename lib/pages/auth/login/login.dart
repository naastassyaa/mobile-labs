import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/components/general/no_internet_connection.dart';
import 'package:test_project/pages/auth/login/login_cubit.dart';
import 'package:test_project/pages/auth/login/login_form.dart';
import 'package:test_project/storage/user_data_storage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create:
          (_) => LoginCubit(storage: context.read<UserDataStorage>())..init(),
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (prev, curr) => prev.hasConnection && !curr.hasConnection,
      listener: (_, __) {
        showDialog<void>(
          context: context,
          builder: (_) => const NoInternetConnectionDialog(),
        );
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        body: BlocConsumer<LoginCubit, LoginState>(
          listenWhen: (prev, curr) => !prev.loginSuccess && curr.loginSuccess,
          listener: (context, state) {
            Navigator.pushReplacementNamed(context, '/home');
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
