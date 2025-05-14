import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:test_project/pages/home/home_cubit.dart';
import 'package:test_project/routes.dart';
import 'package:test_project/storage/shared_preferences.dart';
import 'package:test_project/storage/user_data_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userDataStorage = Preferences();
  final bool isLoggedIn = await userDataStorage.isLoggedIn();

  runApp(
    MultiProvider(
      providers: [
        Provider<UserDataStorage>.value(value: userDataStorage),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(
            create: (_) => HomeCubit()..init(),
          ),
        ],
        child: MyApp(isLoggedIn: isLoggedIn),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({
    required this.isLoggedIn, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: appRoutes,
    );
  }
}
