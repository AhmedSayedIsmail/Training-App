// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:training_app/shared/components/constants.dart';

class DesignTextField extends StatelessWidget {
  final String? hint_text;
  final String? Function(String?)? validation;
  final TextInputType? type;
  final TextEditingController? controller;
  final bool? obscure_text;
  final IconData? perfixIcon;
  final IconData? suffixIcon;
  final Function()? suffixOnClick;
  const DesignTextField(
      {Key? key,
      this.hint_text,
      this.validation,
      this.type,
      this.controller,
      this.obscure_text,
      this.perfixIcon,
      this.suffixIcon,
      this.suffixOnClick})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint_text,
        filled: true,
        fillColor: textFormFieldBackground,
        border: const OutlineInputBorder(),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 3)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade800, width: 5)),
        errorStyle: const TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
        prefixIcon: Icon(perfixIcon),
        suffixIcon:
            IconButton(onPressed: suffixOnClick, icon: Icon(suffixIcon)),
      ),
      validator: validation,
      keyboardType: type,
      controller: controller,
      obscureText: obscure_text!,
    );
  }
}
