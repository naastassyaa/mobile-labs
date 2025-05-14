import 'package:flutter/material.dart';
import 'package:test_project/components/general/custom_button.dart';
import 'package:test_project/components/general/custom_text_field.dart';
import 'package:test_project/components/specific/input_validation.dart';

typedef OnRegister = void Function(String name, String email, String password);

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSubmitting;
  final OnRegister onRegister;
  final VoidCallback onLogin;

  const RegisterForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.isSubmitting,
    required this.onRegister,
    required this.onLogin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Create your account!',
            style: TextStyle(fontSize: 30, color: Colors.lightBlue),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: nameController,
            labelText: 'Name',
            validator: InputValidation.validateName,
          ),
          const SizedBox(height: 20),
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
            onPressed: isSubmitting
                ? null
                : () {
              if (formKey.currentState!.validate()) {
                onRegister(
                  nameController.text.trim(),
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              }
            },
            text: 'Sign up',
            textColor: Colors.white,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              TextButton(
                onPressed: onLogin,
                child: Text(
                  'Log in',
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
