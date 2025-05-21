import 'package:flutter/material.dart';
import 'package:test_project/components/general/custom_text_field.dart';
import 'package:test_project/components/specific/input_validation.dart';

class EditProfileFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController dobController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? gender;
  final void Function(String) onNameChanged;
  final void Function(String) onSurnameChanged;
  final void Function(String) onDobChanged;
  final void Function(String) onEmailChanged;
  final void Function(String) onPhoneChanged;
  final void Function(String?) onGenderChanged;

  const EditProfileFormFields({
    required this.nameController,
    required this.surnameController,
    required this.dobController,
    required this.emailController,
    required this.phoneController,
    required this.gender,
    required this.onNameChanged,
    required this.onSurnameChanged,
    required this.onDobChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    required this.onGenderChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          labelText: 'First Name',
          validator: InputValidation.validateName,
          onChanged: onNameChanged,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: surnameController,
          labelText: 'Last Name',
          validator: InputValidation.validateSurname,
          onChanged: onSurnameChanged,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () async {
            FocusScope.of(context).unfocus();
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: dobController.text.isNotEmpty
                  ? (DateTime.tryParse(dobController.text) ?? DateTime.now())
                  : DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              final iso = pickedDate.toIso8601String().split('T')[0];
              dobController.text = iso;
              onDobChanged(iso);
            }
          },
          child: AbsorbPointer(
            child: CustomTextField(
              controller: dobController,
              labelText: 'Date of Birth',
              validator: InputValidation.validateDob,
              onChanged: onDobChanged,
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: emailController,
          labelText: 'Email',
          validator: InputValidation.validateEmail,
          onChanged: onEmailChanged,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: phoneController,
          labelText: 'Phone Number',
          validator: InputValidation.validatePhone,
          onChanged: onPhoneChanged,
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
          items: ['Male', 'Female', 'Other']
              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              .toList(),
          onChanged: onGenderChanged,
        ),
      ],
    );
  }
}
