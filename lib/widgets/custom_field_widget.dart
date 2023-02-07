import 'package:flutter/material.dart';

class CustomFieldWidget extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?) validator;

  const CustomFieldWidget({
    super.key,
    required this.labelText,
    required this.controller,
    required this.obscureText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          // hintText: hintText,
          labelStyle: TextStyle(color: Colors.grey.shade500),
          floatingLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          fillColor: Colors.grey.shade100,
          filled: true,
        ),
      ),
    );
  }
}
