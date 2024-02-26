class NameValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    final RegExp regex = RegExp(r'^[a-zA-Z0-9 ]+$');
    if (!regex.hasMatch(value)) {
      return 'Please enter alphanumeric characters and spaces only';
    }
    return null;
  }
}
