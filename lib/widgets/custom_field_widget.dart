import 'package:flutter/material.dart';

class CustomFieldWidget extends StatelessWidget {
  final String? labelText;
  final bool obscureText;
  final IconData suffixIcon;
  final double horizontalPadding;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? autoFill;

  const CustomFieldWidget({
    super.key,
    required this.labelText,
    required this.controller,
    required this.obscureText,
    required this.validator,
    required this.suffixIcon,
    required this.horizontalPadding,
    required this.autoFill,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextFormField(
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        autofillHints: [autoFill!],

        // text style
        style: TextStyle(),

        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: Icon(
            suffixIcon,
          ),
          // hintText: hintText,

          // label inside
          // labelStyle: TextStyle(),

          // label above
          // floatingLabelStyle: TextStyle(

          // ),

          // border unfocused
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),

          // border focused
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(),
          // ),

          // fillColor: Theme.of(context).colorScheme.secondary,
          // filled: true,
        ),
      ),
    );
  }
}
