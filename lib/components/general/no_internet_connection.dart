import 'package:flutter/material.dart';

class NoInternetConnectionDialog extends StatelessWidget {
  final String message;

  const NoInternetConnectionDialog({
    super.key,
    this.message = 'No internet connection',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('No Internet'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
