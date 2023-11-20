import 'package:flutter/material.dart';
import '../../../shared/color.dart';

class AuthFormInput extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final double width;
  final double height;
  final void Function(String newValue)? onFieldSubmitted;
  final void Function(String newValue)? onChanged;
  final String? initialValue;
  final String? Function(String? value)? validator;
  const AuthFormInput(
      {required this.hintText,
      required this.width,
      required this.height,
      this.initialValue,
      this.validator,
      this.onFieldSubmitted,
      this.onChanged,
      this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        onChanged: (value) {
          onChanged?.call(value);
        },
        initialValue: initialValue,
        autovalidateMode: AutovalidateMode.disabled,
        validator: (value) {
          return validator?.call(value);
        },
        onFieldSubmitted: (value) {
          onFieldSubmitted?.call(value);
        },
        cursorColor: AppColors.white,
        obscureText: obscure,
        maxLines: 1,
        minLines: 1,
        style: TextStyle(color: AppColors.white, fontSize: 20),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 16),
          isDense: true,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.white, fontSize: 20),
          fillColor: AppColors.accent,
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
