import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final bool isTopField; // La idea es que tenga bordes redondeados arriba
  final bool isBottomField; // La idea es que tenga bordes redondeados abajo
  final String? label;
  final TextAlign? textAlign;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final String initialValue;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    this.isTopField = false,
    this.isBottomField = false,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.initialValue = '',
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.textAlign = TextAlign.start,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
        controller: controller,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Colors.black54),
        maxLines: maxLines,
        initialValue: controller == null ? initialValue : null,
        decoration: InputDecoration(
          floatingLabelBehavior: maxLines > 1
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.auto,
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54), // Borde inferior
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: colors.primary), // Borde inferior activo
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Borde inferior error
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.red), // Borde inferior error activo
          ),
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
        ),
        textAlign: textAlign!);
  }
}