import 'package:flutter/material.dart';
import 'dart:async';

class BhattiFlashingPage extends StatefulWidget {
  const BhattiFlashingPage({super.key});

  @override
  State<BhattiFlashingPage> createState() => _BhattiFlashingPageFlashingPageState();
}

class _BhattiFlashingPageFlashingPageState extends State<BhattiFlashingPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/sign_in');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/bhatti.png',
                width:300
              ),
            ],
          ),
        ),
      ),
    );
  }
}