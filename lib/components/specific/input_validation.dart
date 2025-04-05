class InputValidation {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please, enter email!';
    } else if (!value.contains('@gmail.com')) {
      return 'Email is incorrect!';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please, enter password!';
    }
    if (value.length < 8) {
      return 'Password must contain at least 8 characters!';
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])').hasMatch(value)) {
      return 'Password must contain at least '
          'one uppercase letter and one number!';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please, enter name!';
    }
    return null;
  }

  static String? validateSurname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please, enter surname!';
    }
    return null;
  }

  static String? validateDob(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please, enter date of birth!';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please, enter phone number!';
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return 'Invalid phone number!';
    }
    return null;
  }
}
