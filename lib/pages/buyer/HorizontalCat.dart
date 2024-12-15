import 'package:flutter/material.dart';

class HorizontalLiquorCategory extends StatefulWidget {
  final VoidCallback onPressed;
  final String text, img;
  const HorizontalLiquorCategory(
      {super.key,
        required this.onPressed,
        required this.text,
        required this.img});

  @override
  State<HorizontalLiquorCategory> createState() => _HorizontalLiquorCategoryState();
}

class _HorizontalLiquorCategoryState extends State<HorizontalLiquorCategory> {
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
          height: 80, // Set height to 80
          width: 100, // Set width to 100
          padding: const EdgeInsets.all(8), // Adjust padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2, // Allow image to take more space
                child: Image.asset(
                  widget.img,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 4), // Add some spacing between the image and text
              Expanded(
                flex: 1, // Allow text to take less space
                child: Text(
                  widget.text,
                  style: const TextStyle(fontSize: 11, fontFamily: 'lovelo'),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
