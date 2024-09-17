import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:software_ingenieriaeconomica/screens/home_page.dart';
import 'package:software_ingenieriaeconomica/screens/login_screen.dart';

import 'auth_service.dart';  // Asegúrate de importar AuthService

class AuthWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginPage();
          } else {
            return HomePage();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
