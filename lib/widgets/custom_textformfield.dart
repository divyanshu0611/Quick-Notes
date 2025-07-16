import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText, // hint text inside the field (like "Enter name")
    required this.controller, // used to get or set text in this field

    this.labelText, // label above the field
    this.icon, // suffix icon shown at end
    this.prefixIcon, // icon shown at start
    this.prefixText, // text at the beginning inside the box (like ₹)
    this.suffixText, // text at the end inside the box (like kg)

    this.helperText, // small message below field (like "Only letters")
    this.errorText, // custom error message if needed

    this.isPassword = false, // if true, hides input with *
    this.readOnly = false, // if true, cannot type in field

    this.keyboardType, // type of keyboard (text, number, email etc.)
    this.textInputAction, // action on the keyboard (next, done, etc.)

    this.validator, // function to check if input is correct
    this.onTap, // what happens when user taps (good for date picker)
    this.maxLines = 1, // default: one line text field
    this.borderRadius = 8.0,
    this.onChanged,
    this.inputFormatter,
    this.maxLength, // how round the corners are
  });

  // Required
  final String hintText;
  final TextEditingController controller;

  // Optional UI texts/icons
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final Widget? icon;
  final Widget? prefixIcon;
  final String? prefixText;
  final String? suffixText;

  // Input control
  final bool isPassword;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final double borderRadius;

  // Keyboard settings
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  // Functions
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatter;

  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // autocorrect: true,
      // textCapitalization: TextCapitalization.sentences,
      // enableSuggestions: true,
      // autofocus: true,
      onChanged: onChanged,
      inputFormatters: inputFormatter,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction ?? TextInputAction.next,
      obscureText: isPassword, // hides the input if it's a password
      obscuringCharacter: '*', // symbol used when hiding text
      readOnly: readOnly, // disables typing if true
      onTap: onTap, // tap action (like opening date picker)
      maxLines: maxLines,
      maxLength: maxLength, // number of lines for input

      decoration: InputDecoration(
        // Label shown above when field is focused or has text
        labelText: labelText,

        // Hint shown inside the field when it's empty
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.labelLarge,

        // Helper and error messages
        helperText: helperText,
        errorText: errorText,
        errorStyle: TextStyle(fontSize: 12, color: Colors.red.shade700),

        // Prefix/suffix (icons and text)
        prefixIcon: prefixIcon,
        suffixIcon: icon,
        suffixIconColor: Colors.black,
        prefixText: prefixText,
        suffixText: suffixText,

        // Background and spacing
        filled: true,
        fillColor: Colors.grey.withAlpha(30),
        isDense: true, // makes the field a bit smaller
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),

        // Borders for different states
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(width: 1.3, color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(width: 1.3, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(width: 1.3, color: Colors.red),
        ),
      ),
    );
  }
}
