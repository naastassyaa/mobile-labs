import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/components/general/bottom_nav_bar.dart';
import 'package:test_project/components/specific/edit_form.dart';
import 'package:test_project/components/specific/save_profile_button.dart';
import 'package:test_project/storage/user_data_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _gender;
  String _password = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userDataStorage = Provider.of<UserDataStorage>(context,
          listen: false,);
      _loadProfileData(userDataStorage);
    });
  }

  Future<void> _loadProfileData(UserDataStorage userDataStorage) async {
    final profileData = await userDataStorage.getCurrentUser();
    if (profileData != null && mounted) {
      setState(() {
        _nameController.text = profileData['name']?.toString() ?? '';
        _surnameController.text = profileData['surname']?.toString() ?? '';
        _dobController.text = profileData['dob']?.toString() ?? '';
        _emailController.text = profileData['email']?.toString() ?? '';
        _phoneController.text = profileData['phone']?.toString() ?? '';
        _gender = profileData['gender']?.toString();
        _password = profileData['password']?.toString() ?? 'somePassword';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataStorage = Provider.of<UserDataStorage>(context,
        listen: false,);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Edit Profile', style: TextStyle(color:
        Colors.black,),),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              EditProfileFormFields(
                nameController: _nameController,
                surnameController: _surnameController,
                dobController: _dobController,
                emailController: _emailController,
                phoneController: _phoneController,
                gender: _gender,
                onGenderChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SaveProfileButton(
                onSave: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(const
                    SnackBar(content: Text('Profile Updated')),);
                    await userDataStorage.saveUser(
                      email: _emailController.text.trim(),
                      password: _password,
                      name: _nameController.text.trim(),
                      isLoggedIn: true,
                      surname: _surnameController.text.trim(),
                      dob: _dobController.text.trim(),
                      phone: _phoneController.text.trim(),
                      gender: _gender,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
