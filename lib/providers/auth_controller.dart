import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/user_repository.dart';

enum AuthStatus { loading, signedOut, signedIn }

/// Single source of truth for who is signed in and what role they have.
///
/// The role comes from Firestore (`users/{uid}.role`), not from the email or
/// password typed by the user.
class AuthController extends ChangeNotifier {
  AuthController({
    required AuthService authService,
    required UserRepository userRepository,
  })  : _authService = authService,
        _userRepository = userRepository {
    _subscription = _authService.authStateChanges.listen(_onAuthChanged);
  }

  final AuthService _authService;
  final UserRepository _userRepository;
  late final StreamSubscription<User?> _subscription;

  AuthStatus _status = AuthStatus.loading;
  AppUser? _user;
  bool _registering = false;

  AuthStatus get status => _status;
  AppUser? get user => _user;
  bool get isAdmin => _user?.isAdmin ?? false;

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _registering = true; // the profile is written below, not by the listener
    try {
      final firebaseUser = await _authService.register(email, password);
      final profile = AppUser(
        uid: firebaseUser.uid,
        email: email.trim(),
        name: name.trim(),
      );
      try {
        await _userRepository.createUser(profile);
      } catch (_) {
        // The account exists; the profile is retried on the next sign in.
      }
      _user = profile;
      _status = AuthStatus.signedIn;
      notifyListeners();
    } finally {
      _registering = false;
    }
  }

  Future<void> signOut() => _authService.signOut();

  Future<void> _onAuthChanged(User? firebaseUser) async {
    if (_registering) return;

    if (firebaseUser == null) {
      _user = null;
      _status = AuthStatus.signedOut;
      notifyListeners();
      return;
    }

    try {
      _user = await _userRepository.getUser(firebaseUser.uid) ??
          await _createDefaultProfile(firebaseUser);
    } catch (_) {
      _user = _defaultProfile(firebaseUser);
    }
    _status = AuthStatus.signedIn;
    notifyListeners();
  }

  AppUser _defaultProfile(User firebaseUser) {
    final email = firebaseUser.email ?? '';
    return AppUser(
      uid: firebaseUser.uid,
      email: email,
      name: firebaseUser.displayName ?? email.split('@').first,
      role: UserRole.user,
    );
  }

  Future<AppUser> _createDefaultProfile(User firebaseUser) async {
    final profile = _defaultProfile(firebaseUser);
    try {
      await _userRepository.createUser(profile);
    } catch (_) {
      // Keep going with an in-memory profile.
    }
    return profile;
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
