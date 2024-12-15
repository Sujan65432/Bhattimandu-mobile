import 'package:flutter/material.dart';

class CustomButtonIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const CustomButtonIcon({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(2),
        backgroundColor: const Color(0xff1C1C2E),
        minimumSize: const Size(35, 35), // Adjust the size of the button here
        foregroundColor: Colors.blue, // Icon color
        side: const BorderSide(
          width: 0.5, // Border width
        ),
      ),
      child: icon,
    );
  }
}
