class AppValidator {
  static noValidation() {
    return null;
  }
  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$', caseSensitive: false);
    if (!emailRegex.hasMatch(v)) return 'Enter a valid email address';
    if (v.contains('..')) return 'Email cannot contain consecutive dots';
    return null;
  }
  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';

  return null;
}



  static String? phoneValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'LocaleKeys.enterPhoneNumber.tr()';
    }
    // if (!RegExp(r'^\(\d{3}\) \d{3}-\d{4}$').hasMatch(value)) {
    //   return LocaleKeys.enterValidNumber.tr();
    // }
    return null;
  }

  static String? nameValidation(String? name) {
    if (name == null || name.isEmpty) {
      return 'LocaleKeys.nameRequired.tr()';
    }
    return null;
  }

  static String? addressValidation(String? address) {
    if (address == null || address.isEmpty) {
      return 'LocaleKeys.addressRequired.tr()';
    }
    return null;
  }

  static String? zipCodeValidation(String? zipCode) {
    if (zipCode == null || zipCode.isEmpty) {
      return 'LocaleKeys.zipCodeRequired.tr()';
    }
    if (!RegExp(r'^\d{5}(-\d{4})?$').hasMatch(zipCode)) {
      return 'LocaleKeys.enterValidZipCode.tr()';
    }
    return null;
  }
}
