import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/components/general/custom_button.dart';
import 'package:test_project/components/general/custom_text_field.dart';
import 'package:test_project/components/specific/input_validation.dart';
import 'package:test_project/pages/auth/login/login_cubit.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;

  const LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: 60),
          const Text(
            'Welcome!',
            style: TextStyle(fontSize: 30, color: Colors.lightBlue),
          ),
          const SizedBox(height: 8),
          const Text(
            'Log in and enjoy the app!',
            style: TextStyle(fontSize: 25, color: Colors.lightBlue),
          ),
          const SizedBox(height: 40),
          CustomTextField(
            controller: emailController,
            labelText: 'Email',
            validator: InputValidation.validateEmail,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: passwordController,
            labelText: 'Password',
            obscureText: true,
            validator: InputValidation.validatePassword,
          ),
          const SizedBox(height: 40),
          CustomButton(
            onPressed:
                isLoading
                    ? null
                    : () {
                      if (formKey.currentState!.validate()) {
                        context.read<LoginCubit>().login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      }
                    },
            text: 'Log in',
            textColor: Colors.white,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue.shade400,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
            child: Text(
              'Forgot password?',
              style: TextStyle(color: Colors.lightBlue.shade400),
            ),
          ),
          const SizedBox(height: 8),
          const Text('or'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text(
                  'Register now',
                  style: TextStyle(color: Colors.lightBlue.shade400),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
