import 'package:flutter/material.dart';
import 'package:test_project/routes.dart';
import 'package:test_project/storage/shared_preferences.dart';
import 'package:test_project/storage/user_data_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final UserDataStorage userDataStorage = Preferences();
  final bool isLoggedIn = await userDataStorage.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: appRoutes,
    );
  }
}
