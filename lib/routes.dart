import 'package:flutter/material.dart';
import 'package:test_project/pages/edit_profile.dart';
import 'package:test_project/pages/home.dart';
import 'package:test_project/pages/login.dart';
import 'package:test_project/pages/profile.dart';
import 'package:test_project/pages/register.dart';
import 'package:test_project/pages/scan.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
  '/home': (context) => const HomePage(),
  '/scan': (context) => const ScanFridgePage(),
  '/profile': (context) => const ProfilePage(),
  '/edit': (context) => const EditProfilePage(),
};
