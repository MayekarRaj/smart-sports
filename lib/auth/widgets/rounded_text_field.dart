import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffix;
  const RoundedTextField({super.key, required this.controller, required this.hint, this.keyboardType = TextInputType.text, this.validator, this.suffix});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(hintText: hint, suffixIcon: suffix),
    );
  }
}
