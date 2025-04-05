import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/routes.dart';
import 'package:test_project/storage/shared_preferences.dart';
import 'package:test_project/storage/user_data_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userDataStorage = Preferences();
  final bool isLoggedIn = await userDataStorage.isLoggedIn();

  runApp(
    Provider<UserDataStorage>.value(
      value: userDataStorage,
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: appRoutes,
    );
  }
}
