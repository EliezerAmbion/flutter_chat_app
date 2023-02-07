import 'package:flutter/material.dart';

class CustomFieldWidget extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

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
        cursorColor: Theme.of(context).colorScheme.tertiary,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        controller: controller,
        obscureText: obscureText,

        // text style
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),

        decoration: InputDecoration(
          labelText: labelText,
          // hintText: hintText,

          // label inside
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyText2!.color,
          ),

          // label above
          floatingLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),

          // border unfocused
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // border focused
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          // fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
