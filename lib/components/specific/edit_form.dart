import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/components/general/custom_text_field.dart';
import 'package:test_project/components/specific/input_validation.dart';
import 'package:test_project/pages/edit_profile/edit_profile_cubit.dart';

class EditProfileFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController dobController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? gender;

  const EditProfileFormFields({
    required this.nameController,
    required this.surnameController,
    required this.dobController,
    required this.emailController,
    required this.phoneController,
    required this.gender,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();

    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          labelText: 'First Name',
          validator: InputValidation.validateName,
          onChanged: (val) => cubit.updateField(name: val),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: surnameController,
          labelText: 'Last Name',
          validator: InputValidation.validateSurname,
          onChanged: (val) => cubit.updateField(surname: val),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () async {
            FocusScope.of(context).unfocus();
            final pickedDate = await showDatePicker(
              context: context,
              initialDate:
                  dobController.text.isNotEmpty
                      ? (DateTime.tryParse(dobController.text) ??
                          DateTime.now())
                      : DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              final iso = pickedDate.toIso8601String().split('T')[0];
              dobController.text = iso;
              cubit.updateField(dob: iso);
            }
          },
          child: AbsorbPointer(
            child: CustomTextField(
              controller: dobController,
              labelText: 'Date of Birth',
              validator: InputValidation.validateDob,
              onChanged: (val) => cubit.updateField(dob: val),
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: emailController,
          labelText: 'Email',
          validator: InputValidation.validateEmail,
          onChanged: (val) => cubit.updateField(email: val),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: phoneController,
          labelText: 'Phone Number',
          validator: InputValidation.validatePhone,
          onChanged: (val) => cubit.updateField(phone: val),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          isExpanded: true,
          value: gender,
          hint: const Text('Select Gender'),
          items:
              [
                'Male',
                'Female',
                'Other',
              ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
          onChanged: (val) => cubit.updateField(gender: val),
        ),
      ],
    );
  }
}
