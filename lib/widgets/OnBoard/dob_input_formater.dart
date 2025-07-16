
import 'package:flutter/services.dart';

class DOBInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit input to 8 digits: DDMMYYYY
    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8);
    }

    StringBuffer buffer = StringBuffer();

    if (digitsOnly.length >= 2) {
      final day = int.tryParse(digitsOnly.substring(0, 2));
      if (day == null || day < 1 || day > 31) return oldValue;
      buffer.write(digitsOnly.substring(0, 2));
      if (digitsOnly.length >= 3) buffer.write('/');
    } else if (digitsOnly.isNotEmpty) {
      buffer.write(digitsOnly.substring(0, digitsOnly.length));
    }

    if (digitsOnly.length >= 4) {
      final month = int.tryParse(digitsOnly.substring(2, 4));
      if (month == null || month < 1 || month > 12) return oldValue;
      buffer.write(digitsOnly.substring(2, 4));
      if (digitsOnly.length >= 5) buffer.write('/');
    } else if (digitsOnly.length > 2) {
      buffer.write(digitsOnly.substring(2));
    }

    if (digitsOnly.length > 4) {
      buffer.write(digitsOnly.substring(4));
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}