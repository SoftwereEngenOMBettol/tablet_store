import '../constants/app_constants.dart';

/// Form validators. Each returns an error message, or `null` when valid.
class Validators {
  const Validators._();

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? notEmpty(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? email(String? value) {
    final empty = notEmpty(value, field: 'Email');
    if (empty != null) return empty;
    return _emailPattern.hasMatch(value!.trim())
        ? null
        : 'Enter a valid email address';
  }

  static String? password(String? value) {
    if (value == null || value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    return null;
  }

  static String? price(String? value) {
    final empty = notEmpty(value, field: 'Price');
    if (empty != null) return empty;
    final parsed = double.tryParse(value!.trim());
    if (parsed == null) return 'Enter a valid number';
    if (parsed <= 0) return 'Price must be greater than zero';
    return null;
  }

  static String? imageUrl(String? value) {
    final empty = notEmpty(value, field: 'Image URL');
    if (empty != null) return empty;
    final uri = Uri.tryParse(value!.trim());
    if (uri == null ||
        !(uri.isScheme('http') || uri.isScheme('https')) ||
        uri.host.isEmpty) {
      return 'Enter a valid http(s) URL';
    }
    return null;
  }
}
