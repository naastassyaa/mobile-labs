import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/components/general/custom_button.dart';
import 'package:test_project/components/general/custom_textfield.dart';
import 'package:test_project/components/general/no_internet_connection.dart';
import 'package:test_project/components/specific/input_validation.dart';
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
  late final UserDataStorage _storage;
  bool _isLoading = false;
  bool _hasInternet = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _storage = Provider.of<UserDataStorage>(context, listen: false);
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((results) {
      final status = results.first;
      _updateConnectionStatus(status);
    });
    _checkInitialConnectivity();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryAutoLogin());
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result as ConnectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final newStatus = result != ConnectivityResult.none;
    if (newStatus != _hasInternet) {
      setState(() => _hasInternet = newStatus);
      if (!_hasInternet) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          showDialog<void>(
            context: context,
            builder: (_) => const NoInternetConnectionDialog(),
          );
        });
      }
    }
  }

  Future<void> _tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('currentUserEmail');
    if (email == null) return;
    final userData = await _storage.getUser(email);
    if (userData == null) return;
    await _storage.updateLoginStatus(email, true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  Future<void> _login(UserDataStorage storage) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    String? snackMessage;
    bool loginSuccess = false;

    try {
      final userData = await storage.getUser(email);
      if (userData == null) {
        snackMessage = 'User not found';
      } else if (userData['password'] != password) {
        snackMessage = 'Incorrect password';
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('currentUserEmail', email);
        await storage.updateLoginStatus(email, true);
        loginSuccess = true;
      }
    } catch (e) {
      snackMessage = 'Login error: $e';
    }

    if (mounted) setState(() => _isLoading = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (loginSuccess) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (snackMessage != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(snackMessage)));
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<UserDataStorage>(context, listen: false);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
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
                    onPressed:
                    _isLoading ? null : () => _login(storage),
                    text: 'Log in',
                    textColor: Colors.white,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/'),
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
                        onPressed: () =>
                            Navigator.pushNamed(context, '/register'),
                        child: Text(
                          'Register now',
                          style:
                          TextStyle(color: Colors.lightBlue.shade400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
