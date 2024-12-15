import 'package:flutter/material.dart';

class CustomCartBtn extends StatelessWidget {
  final String text;
  final Icon? icon;
  final VoidCallback onPressed;

  const CustomCartBtn({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        fixedSize: const Size(double.infinity, 30),
        backgroundColor: Colors.red,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          if (icon != null) const SizedBox(width: 8), // Add spacing between icon and text
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
