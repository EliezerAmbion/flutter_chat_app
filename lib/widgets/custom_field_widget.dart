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
        style: Theme.of(context).textTheme.headline5,

        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: Icon(
            suffixIcon,
            color: Theme.of(context).colorScheme.secondary,
          ),

          // label inside
          labelStyle: Theme.of(context).textTheme.headline6,

          // label above
          floatingLabelStyle: Theme.of(context).textTheme.headline6,

          // border unfocused
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // border focused
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
