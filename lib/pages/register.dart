import 'package:flutter/material.dart';
import 'package:test_project/components/custom_button.dart';
import 'package:test_project/components/custom_textfield.dart';
import 'package:test_project/components/input_validation.dart';
import 'package:test_project/storage/shared_preferences.dart';
import 'package:test_project/storage/user_data_storage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late UserDataStorage _userDataStorage;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _userDataStorage = Preferences();
  }

  Future<void> _checkLoginStatus() async {
    final bool isLoggedIn = await _userDataStorage.isLoggedIn();
    if (isLoggedIn) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _register() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      await _userDataStorage.saveUser(
        email: email,
        password: password,
        name: name,
        isLoggedIn: true,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create your account!',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.lightBlue,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Name',
                  validator: InputValidation.validateName,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  validator: InputValidation.validateEmail,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                  validator: InputValidation.validatePassword,
                ),
                const SizedBox(height: 40),
                CustomButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue.shade400,
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    await _register();
                  },
                  text: 'Sign up',
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(color: Colors.lightBlue.shade400),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
