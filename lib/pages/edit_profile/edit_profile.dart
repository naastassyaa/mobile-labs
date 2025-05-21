import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/components/general/bottom_nav_bar.dart';
import 'package:test_project/components/general/no_internet_connection.dart';
import 'package:test_project/components/specific/edit_form.dart';
import 'package:test_project/components/specific/save_profile_button.dart';
import 'package:test_project/pages/edit_profile/edit_profile_cubit.dart';
import 'package:test_project/storage/user_data_storage.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileCubit>(
      create: (context) => EditProfileCubit(
        storage: context.read<UserDataStorage>(),
      )..init(),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();
  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EditProfileCubit>().stream.listen((state) {
      if (state.loaded) {
        _nameCtrl.text = state.name ?? '';
        _surnameCtrl.text = state.surname ?? '';
        _dobCtrl.text = state.dob ?? '';
        _emailCtrl.text = state.email ?? '';
        _phoneCtrl.text = state.phone ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _dobCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listenWhen: (prev, curr) =>
      prev.hasConnection && !curr.hasConnection,
      listener: (_, __) => showDialog<void>(
        context: context,
        builder: (_) => const NoInternetConnectionDialog(),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Edit Profile',
              style: TextStyle(color: Colors.black),),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state.saveSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile Updated')),
              );
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    EditProfileFormFields(
                      nameController: _nameCtrl,
                      surnameController: _surnameCtrl,
                      dobController: _dobCtrl,
                      emailController: _emailCtrl,
                      phoneController: _phoneCtrl,
                      gender: state.gender,
                      onNameChanged: (val) =>
                          context.read<EditProfileCubit>()
                              .updateField(name: val),
                      onSurnameChanged: (val) =>
                          context.read<EditProfileCubit>()
                              .updateField(surname: val),
                      onDobChanged: (val) =>
                          context.read<EditProfileCubit>()
                              .updateField(dob: val),
                      onEmailChanged: (val) =>
                          context.read<EditProfileCubit>()
                              .updateField(email: val),
                      onPhoneChanged: (val) =>
                          context.read<EditProfileCubit>()
                              .updateField(phone: val),
                      onGenderChanged: (val) =>
                          context.read<EditProfileCubit>()
                              .updateField(gender: val),
                    ),
                    const SizedBox(height: 20),
                    SaveProfileButton(
                      onSave: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<EditProfileCubit>().saveProfile();
                        }
                      },
                    ),
                    if (state.isSubmitting)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      ),
    );
  }
}
