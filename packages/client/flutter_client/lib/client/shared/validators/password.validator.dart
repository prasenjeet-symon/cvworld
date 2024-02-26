class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    // Regular expression for basic password validation
    final RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    if (!regex.hasMatch(value)) {
      return 'Password must contain at least 8 characters, including uppercase, lowercase, and numbers';
    }
    return null;
  }
}
