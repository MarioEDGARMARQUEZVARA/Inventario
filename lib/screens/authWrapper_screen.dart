import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventario_proyecto/screens/auth_screen.dart';
import 'package:inventario_proyecto/screens/principal_screen.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Usuario logueado - mostrar PrincipalScreen con SessionProvider
        if (snapshot.hasData) {
          return ChangeNotifierProvider(
            create: (_) => SessionProvider(),
            child: const PrincipalScreen(),
          );
        }

        // Usuario no logueado - mostrar AuthScreen
        return const AuthScreen();
      },
    );
  }
}