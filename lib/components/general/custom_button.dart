import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle style;
  final Color textColor;
  final IconData? icon;
  final TextAlign textAlign;

  const CustomButton({
    required this.onPressed,
    required this.style,
    required this.text,
    required this.textColor,
    this.icon,
    this.textAlign = TextAlign.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (icon != null) Icon(icon, color: textColor),
          Expanded(
            child: Text(
              text,
              textAlign: textAlign,
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
