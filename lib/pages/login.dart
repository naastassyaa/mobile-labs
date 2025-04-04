import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/components/custom_button.dart';
import 'package:test_project/components/custom_textfield.dart';
import 'package:test_project/components/input_validation.dart';
import 'package:test_project/storage/shared_preferences.dart';
import 'package:test_project/storage/user_data_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final bool isLoggedIn = await _userDataStorage.isLoggedIn();
    if (isLoggedIn && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final userData = await _userDataStorage.getUser(email);
    if (!mounted) return;
    if (userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User with this email not found')),
      );
    } else if (userData['password'] == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentUserEmail', email);
      await _userDataStorage.updateLoginStatus(email, true);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Incorrect password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(fontSize: 30, color: Colors.lightBlue),
                    ),
                    SizedBox(height: 1),
                    Text(
                      ' Log in and enjoy the app!',
                      style: TextStyle(fontSize: 25, color: Colors.lightBlue),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  text: 'Log in',
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.lightBlue.shade400),
                  ),
                ),
                const Text('or'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Register now',
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
