import 'package:flutter/material.dart';

class SaveProfileButton extends StatelessWidget {
  final VoidCallback onSave;

  const SaveProfileButton({required this.onSave, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSave,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text('Save Changes'),
    );
  }
}
