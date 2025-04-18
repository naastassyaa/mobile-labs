import 'package:flutter/material.dart';
import 'package:test_project/components/general/custom_button.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onLogout;

  const ActionButtons({required this.onLogout, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius:
              BorderRadius.circular(16),),
            ),
            icon: Icons.support_agent,
            text: 'Technical Support',
            textColor: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius:
              BorderRadius.circular(16),),
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
            onPressed: onLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius:
              BorderRadius.circular(16),),
            ),
            icon: Icons.logout,
            text: 'Logout',
            textColor: Colors.black,
          ),
        ),
      ],
    );
  }
}
