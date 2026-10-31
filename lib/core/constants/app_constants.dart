/// App-wide constants.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Tablet Store';
  static const String currency = 'OMR';
  static const int minPasswordLength = 6;
}

/// Firestore collection names. `item` is kept for compatibility with existing data.
class FirestorePaths {
  const FirestorePaths._();

  static const String products = 'item';
  static const String users = 'users';
  static const String history = 'history';
}

/// Roles stored in `users/{uid}.role`.
class UserRole {
  const UserRole._();

  static const String user = 'user';
  static const String admin = 'admin';
}

class AppAssets {
  const AppAssets._();

  static const String logo = 'assets/images/Logo.png';
  static const String logoIcon = 'assets/images/LogoIcon.png';
}
