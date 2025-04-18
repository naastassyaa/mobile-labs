import 'package:flutter/material.dart';
import 'package:test_project/components/general/custom_textfield.dart';
import 'package:test_project/components/specific/input_validation.dart';

class EditProfileFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController dobController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? gender;
  final void Function(String?) onGenderChanged;

  const EditProfileFormFields({
    required this.nameController,
    required this.surnameController,
    required this.dobController,
    required this.emailController,
    required this.phoneController,
    required this.gender,
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
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: surnameController,
          labelText: 'Last Name',
          validator: InputValidation.validateSurname,
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
              dobController.text = pickedDate.toIso8601String().split('T')[0];
            }
          },
          child: AbsorbPointer(
            child: CustomTextField(
              controller: dobController,
              labelText: 'Date of Birth',
              validator: InputValidation.validateDob,
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: emailController,
          labelText: 'Email',
          validator: InputValidation.validateEmail,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: phoneController,
          labelText: 'Phone Number',
          validator: InputValidation.validatePhone,
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
          items: ['Male', 'Female', 'Other'].map((gender) {
            return DropdownMenuItem<String>(value: gender, child: Text(gender));
          }).toList(),
          onChanged: onGenderChanged,
        ),
      ],
    );
  }
}
