import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final VoidCallback? onTap;
  bool readOnly;
  int maxLines;

  CustomTextField({
    Key? key,
    required this.controller,
    this.label = "",
    this.hint = "",
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: const OutlineInputBorder(borderSide: BorderSide(width: 5)),
          hintText: hint,
          label: Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xff1E1F20)),
          ),
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xff1E1F20))),
    );
  }
}
