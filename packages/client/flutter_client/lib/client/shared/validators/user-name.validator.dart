class UsernameValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter username';
    }
    final RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!regex.hasMatch(value)) {
      return 'Please enter alphanumeric characters only';
    }
    return null;
  }
}
