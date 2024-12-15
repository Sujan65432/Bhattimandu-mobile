class Validators {
  static String? validateUserName(String value) {
    if (value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  static String? validateFullName(String value) {
    if (value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  static String? validateUserPhone(String value) {
    if (value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? validateUserEmail(String value) {
    if (value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validateUserPassword(String value) {
    if (value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
}
