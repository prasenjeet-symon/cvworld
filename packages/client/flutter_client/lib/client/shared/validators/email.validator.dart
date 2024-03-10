class EmailValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    // Regular expression for basic email validation
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
