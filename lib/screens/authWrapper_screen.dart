import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventario_proyecto/screens/auth_screen.dart';
import 'package:inventario_proyecto/screens/principal_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        // Usuario logueado
        if (snapshot.hasData) {
          return PrincipalScreen();
        }

        // Usuario no logueado
        return AuthScreen();
      },
    );
  }
}