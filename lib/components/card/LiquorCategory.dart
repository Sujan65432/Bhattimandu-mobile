import 'package:flutter/material.dart';

class LiquorCategory extends StatefulWidget {
  final VoidCallback onPressed;
  final String text, img;
  const LiquorCategory(
      {super.key,
        required this.onPressed,
        required this.text,
        required this.img});

  @override
  State<LiquorCategory> createState() => _LiquorCategoryState();
}

class _LiquorCategoryState extends State<LiquorCategory> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Card(
        color: const Color(0xff1C1C2E),
        elevation: 2,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.img,
                fit: BoxFit.cover,
              ),
              Text(
                widget.text,
                style: const TextStyle(fontSize: 11,fontFamily: 'lovelo'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
