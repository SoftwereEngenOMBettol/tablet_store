import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/app_constants.dart';

/// Profile stored at `users/{uid}`. Passwords are never stored here.
class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    this.role = UserRole.user,
  });

  final String uid;
  final String email;
  final String name;
  final String role;

  bool get isAdmin => role == UserRole.admin;

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) => AppUser(
        uid: uid,
        email: data['email'] as String? ?? '',
        name: data['name'] as String? ?? '',
        role: data['role'] as String? ?? UserRole.user,
      );

  Map<String, dynamic> toMap() => {
        'email': email,
        'name': name,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
