import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/components/general/bottom_nav_bar.dart';
import 'package:test_project/components/specific/actions_buttons.dart';
import 'package:test_project/components/specific/device_list.dart';
import 'package:test_project/components/specific/profile_header.dart';
import 'package:test_project/storage/user_data_storage.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? firstName;
  String? lastName;

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
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _logout(BuildContext context) async {
    final userDataStorage = Provider.of<UserDataStorage>(context,
        listen: false,);
    await userDataStorage.logoutUser();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
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
