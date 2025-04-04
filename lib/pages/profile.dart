import 'package:flutter/material.dart';
import 'package:test_project/components/bottom_nav_bar.dart';
import 'package:test_project/components/custom_button.dart';
import 'package:test_project/components/profile_header.dart';
import 'package:test_project/storage/shared_preferences.dart';
import 'package:test_project/storage/user_data_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? firstName;
  String? lastName;
  late UserDataStorage _userDataStorage;

  @override
  void initState() {
    super.initState();
    _userDataStorage = Preferences();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    firstName = await _userDataStorage.getFirstName();
    lastName = await _userDataStorage.getLastName();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _userDataStorage.logoutUser();
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
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icons.support_agent,
                text: 'Technical Support',
                textColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  title: const Text(
                    'Devices List',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  children: List.generate(5, (index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Icon(
                          Icons.devices,
                          color: Colors.blue.shade700,
                          size: 30,
                        ),
                        title: Text(
                          'Device ${index + 1}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text('Device details here'),
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blue.shade700,
                            size: 25,
                          ),
                        ),
                        onTap: () {},
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icons.add,
                text: 'Add New Device',
                textColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icons.logout,
                text: 'Logout',
                textColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
