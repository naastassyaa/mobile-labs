import 'package:flutter/material.dart';
import 'package:test_project/pages/auth/login/login.dart';
import 'package:test_project/pages/auth/register/register.dart';
import 'package:test_project/pages/edit_profile/edit_profile.dart';
import 'package:test_project/pages/history/history_page.dart';
import 'package:test_project/pages/home/home.dart';
import 'package:test_project/pages/profile/profile.dart';
import 'package:test_project/pages/scan/scan.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
  '/home': (context) => HomePage(
    initialProducts: ModalRoute.of(context)?.settings.arguments
    as List<String>?,),
  '/scan': (context) => const ScanFridgePage(),
  '/profile': (context) => const ProfilePage(),
  '/edit': (context) => const EditProfilePage(),
  '/history': (context) => const ScanHistoryPage(),
};
