import 'package:flutter/material.dart';

class CustomFileUpload extends StatefulWidget {
  final String label, labelText,upload;
  final double wid;
  final double? height;
  final VoidCallback onPressed;

  const CustomFileUpload({
    super.key,
    required this.label,
    required this.onPressed,
    required this.labelText, required this.upload, required this.height, required this.wid,
  });

  @override
  State<CustomFileUpload> createState() => _CustomFileUploadState();
}

class _CustomFileUploadState extends State<CustomFileUpload> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: null,
      width: MediaQuery.of(context).size.width / widget.wid,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontFamily: 'poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),
          OutlinedButton.icon(
            onPressed: widget.onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.black,
              fixedSize: Size(double.infinity, widget.height as double),
              side: const BorderSide(
                color: Colors.white,
                width: 1.5,
                style: BorderStyle.solid,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            icon: const Icon(
              Icons.add_a_photo_outlined,
              color: Colors.white,
            ),
            label: Text(
              widget.upload,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
