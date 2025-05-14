import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/components/general/bottom_nav_bar.dart';
import 'package:test_project/components/specific/actions_buttons.dart';
import 'package:test_project/components/specific/device_list.dart';
import 'package:test_project/components/specific/profile_header.dart';
import 'package:test_project/pages/profile/profile_cubit.dart';
import 'package:test_project/pages/qr_scan/qr_scan.dart';
import 'package:test_project/storage/user_data_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(
        storage: context.read<UserDataStorage>(),
      ),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) => curr.logoutSuccess && !prev.logoutSuccess,
      listener: (_, __) {
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                buildWhen: (p, c) =>
                p.firstName != c.firstName || p.lastName != c.lastName,
                builder: (context, state) {
                  return ProfileHeader(
                    firstName: state.firstName,
                    lastName: state.lastName,
                    onEditProfile: () => Navigator.pushNamed(context, '/edit'),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final connected =
                  await context.read<ProfileCubit>().isControllerConnected();
                  if (!connected) {
                    if (!context.mounted) return;
                    await showDialog<void>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                          'The controller was not found. '
                            'Make sure you are connected to the correct Wi-Fi.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  String? password;
                  if (!context.mounted) return;
                  await showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Enter the password for the MCU'),
                      content: TextField(
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Password'),
                        onChanged: (v) => password = v,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  );
                  if (password == null || password!.isEmpty) return;
                  if (!context.mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QRScanPage(password: password!),
                    ),
                  );
                },
                child: const Text('Customize MCU'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/history'),
                child: const Text('View scan history'),
              ),
              const SizedBox(height: 20),
              const DeviceList(),
              const SizedBox(height: 20),
              ActionButtons(
                onLogout: () => context.read<ProfileCubit>().logout(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      ),
    );
  }
}
