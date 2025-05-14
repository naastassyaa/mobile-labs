import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/components/general/no_internet_connection.dart';
import 'package:test_project/pages/auth/register/register_cubit.dart';
import 'package:test_project/pages/auth/register/register_form.dart';
import 'package:test_project/storage/user_data_storage.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (_) => RegisterCubit(
          storage: context.read<UserDataStorage>(),)..init(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();
  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (prev, curr) => prev.hasConnection && !curr.hasConnection,
      listener: (_, __) => showDialog<void>(
        context: context,
        builder: (_) => const NoInternetConnectionDialog(),
      ),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state.alreadyLoggedIn || state.registrationSuccess) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: RegisterForm(
                formKey: _formKey,
                nameController: _nameController,
                emailController: _emailController,
                passwordController: _passwordController,
                isSubmitting: state.isSubmitting,
                onRegister: (name, email, pass) =>
                    context.read<RegisterCubit>().register(name, email, pass),
                onLogin: () => Navigator.pushNamed(context, '/login'),
              ),
            );
          },
        ),
      ),
    );
  }
}
