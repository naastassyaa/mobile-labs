import 'package:flutter/material.dart';
import 'package:test_project/pages/auth/login.dart';
import 'package:test_project/pages/auth/register.dart';
import 'package:test_project/pages/edit_profile.dart';
import 'package:test_project/pages/home.dart';
import 'package:test_project/pages/profile.dart';
import 'package:test_project/pages/scan.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
  '/home': (context) => HomePage(
    initialProducts: ModalRoute.of(context)?.settings.arguments
    as List<String>?,),
  '/scan': (context) => const ScanFridgePage(),
  '/profile': (context) => const ProfilePage(),
  '/edit': (context) => const EditProfilePage(),
};
