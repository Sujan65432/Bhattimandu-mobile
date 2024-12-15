import 'package:flutter/material.dart';

class CustomBhattiBtn extends StatelessWidget {
  final String text;
  final Icon? icon;
  final VoidCallback onPressed;

  const CustomBhattiBtn({
    super.key,
    required this.text,
     this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.red,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      icon: icon,
      iconAlignment: IconAlignment.end,
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
