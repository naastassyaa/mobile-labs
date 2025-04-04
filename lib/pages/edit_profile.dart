import 'package:flutter/material.dart';
import 'package:test_project/components/bottom_nav_bar.dart';
import 'package:test_project/components/custom_textfield.dart';
import 'package:test_project/components/input_validation.dart';
import 'package:test_project/storage/shared_preferences.dart';
import 'package:test_project/storage/user_data_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _gender;
  String _password = '';
  late UserDataStorage _userDataStorage;

  @override
  void initState() {
    super.initState();
    _userDataStorage = Preferences();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final profileData = await _userDataStorage.getCurrentUser();
    if (profileData != null) {
      setState(() {
        _nameController.text = profileData['name'] as String? ?? '';
        _surnameController.text = profileData['surname'] as String? ?? '';
        _dobController.text = profileData['dob'] as String? ?? '';
        _emailController.text = profileData['email'] as String? ?? '';
        _phoneController.text = profileData['phone'] as String? ?? '';
        _gender = profileData['gender'] as String?;
        _password = profileData['password'] as String? ?? 'somePassword';
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load profile data.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'First Name',
                validator: InputValidation.validateName,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _surnameController,
                labelText: 'Last Name',
                validator: InputValidation.validateSurname,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate:
                        _dobController.text.isNotEmpty
                            ? (DateTime.tryParse(_dobController.text) ??
                                DateTime.now())
                            : DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dobController.text =
                          pickedDate.toIso8601String().split('T')[0];
                    });
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: _dobController,
                    labelText: 'Date of Birth',
                    validator: InputValidation.validateDob,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                validator: InputValidation.validateEmail,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                validator: InputValidation.validatePhone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                isExpanded: true,
                value: _gender,
                hint: const Text('Select Gender'),
                items:
                    ['Male', 'Female', 'Other']
                        .map(
                          (gender) => DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile Updated')),
                    );
                    await _userDataStorage.saveUser(
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
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
