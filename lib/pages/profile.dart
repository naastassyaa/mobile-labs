import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test_project/components/general/bottom_nav_bar.dart';
import 'package:test_project/components/specific/actions_buttons.dart';
import 'package:test_project/components/specific/device_list.dart';
import 'package:test_project/components/specific/profile_header.dart';
import 'package:test_project/services/qr_scan_page.dart';
import 'package:test_project/storage/user_data_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? firstName;
  String? lastName;
  static const _mcuUrl = 'http://192.168.1.150';

  @override
  void initState() {
    super.initState();
    final userDataStorage = Provider.of<UserDataStorage>(context,
        listen: false,);
    _loadUserData(userDataStorage);
  }

  Future<void> _loadUserData(UserDataStorage userDataStorage) async {
    firstName = await userDataStorage.getFirstName();
    lastName = await userDataStorage.getLastName();
    if (mounted) setState(() {});
  }

  Future<void> _logout(BuildContext context) async {
    final userDataStorage = Provider.of<UserDataStorage>(context,
        listen: false,);
    await userDataStorage.logoutUser();
    if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  Future<bool> _isControllerConnected() async {
    final uri = Uri.parse('$_mcuUrl/status');
    try {
      final resp = await http.get(uri).timeout(const Duration(seconds: 2));
      return resp.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _onSetupMC() async {
    final connected = await _isControllerConnected();
    if (!connected) {
      if (!mounted) return;
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
              child: const Text('ОК'),
            ),
          ],
        ),
      );
      return;
    }

    String? password;
    if (!mounted) return;
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
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QRScanPage(password: password!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ProfileHeader(
              firstName: firstName,
              lastName: lastName,
              onEditProfile: () {
                Navigator.pushNamed(context, '/edit');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSetupMC,
              child: const Text('Customize mcu'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
              child: const Text('View scan history'),
            ),
            const SizedBox(height: 20),
            const DeviceList(),
            const SizedBox(height: 20),
            ActionButtons(onLogout: () => _logout(context)),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
