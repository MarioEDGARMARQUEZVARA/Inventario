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
        final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un loading mientras verifica el estado de autenticación
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Si el usuario está autenticado, ir a PrincipalScreen
        if (snapshot.hasData && snapshot.data != null) {
          // Iniciar sesión en el provider cuando el usuario se autentica
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!sessionProvider.isSessionActive) {
              sessionProvider.startSession();
              print('🚀 SESIÓN INICIADA desde AuthWrapper');
            }
          });
          
          return const PrincipalScreen();
        }
        
        // Si no está autenticado, ir a LoginScreen
        return const AuthScreen();
      },
    );
  }
}