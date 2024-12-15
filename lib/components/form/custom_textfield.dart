import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final String? helperText, suffix, prefix;
  final TextStyle? helperStyle;
  final Icon? icon;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final bool isObscure;
  final int? maxLines;
  final VoidCallback? onIconPressed;
  final String? initialValue;
  // Initial value for the field

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.onChanged,
    this.helperText,
    this.helperStyle,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.isObscure = false,
    this.maxLines = 1,
    this.icon,
    this.onIconPressed,
    this.suffix,
    this.prefix,
     this.initialValue,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.5,
        color: Color(0xffF5F5DC),
      ),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontFamily: 'poppins',
            fontSize: 14,
            color: Color(0xffF5F5DC),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: _controller,
          obscureText: widget.isObscure,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixText: widget.prefix,
            prefixStyle: const TextStyle(
              fontFamily: 'poppins',
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            suffixText: widget.suffix,
            suffixStyle: const TextStyle(
              fontFamily: 'poppins',
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            suffixIcon: widget.isObscure
                ? IconButton(
              icon: Icon(
                widget.isObscure
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.white,
              ),
              onPressed: widget.onIconPressed,
            )
                : widget.icon,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w400,
            ),
            helperText: widget.helperText,
            helperStyle: widget.helperStyle ?? const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w400,
            ),
            errorText: widget.errorText,
            filled: true,
            fillColor: Colors.black,
            enabledBorder: border,
            focusedBorder: border,
          ),
        ),
      ],
    );
  }
}
