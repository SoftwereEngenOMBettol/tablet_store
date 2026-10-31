import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_controller.dart';
import 'admin/admin_screen.dart';
import 'auth/welcome_screen.dart';
import 'home/home_screen.dart';

/// Chooses the first screen from the auth state and the user's role.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return switch (auth.status) {
      AuthStatus.loading => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      AuthStatus.signedOut => const WelcomeScreen(),
      AuthStatus.signedIn =>
        auth.isAdmin ? const AdminScreen() : const HomeScreen(),
    };
  }
}
