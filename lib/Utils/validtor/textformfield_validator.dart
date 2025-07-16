import 'package:intl/intl.dart';

class TextFormFieldValidator {
  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First Name is required';
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return 'Only letters and spaces allowed';
    } else if (value.trim().length < 3) {
      return 'First Name must be at least 3 characters';
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last Name is required';
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return 'Only letters and spaces allowed';
    } else if (value.trim().length < 3) {
      return 'Last Name must be at least 3 characters';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Only digits are allowed';
    } else if (value.trim().length != 10) {
      return 'Phone number must be exactly 10 digits';
    }
    return null;
  }

  static String? validateEmailId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    // Regular expression for validating email
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }

    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }

    // Strong password check
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{6,}$';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Use letters, numbers, and a symbol';
    }

    return null; // valid
  }

  static String? validateDOB(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of Birth is required';
    }

    try {
      // Format matches '06 November, 2003'
      DateTime dob = DateFormat('dd MMMM, yyyy').parseStrict(value);

      final today = DateTime.now();
      int age = today.year - dob.year;
      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        age--;
      }

      if (age < 0 || age > 120) {
        return 'Enter a valid DOB';
      } else if (age < 13) {
        return 'You must be at least 13 years old';
      }
    } catch (e) {
      return 'Invalid date format (e.g., 06 November, 2003)';
    }

    return null;
  }
}
