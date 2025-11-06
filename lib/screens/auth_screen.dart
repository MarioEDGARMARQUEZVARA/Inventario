import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true; 
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Ocurrió un error";
      if (e.code == 'user-not-found') {
        errorMessage = "Usuario no encontrado";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Contraseña incorrecta";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "El correo ya está registrado";
      } else if (e.code == 'weak-password') {
        errorMessage = "La contraseña es muy débil";
      } else if (e.code == 'invalid-email') {
        errorMessage = "El formato del correo es inválido";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "La contraseña es requerida";
    }
    
    // Validar longitud mínima
    if (value.length < 6) {
      return "La contraseña debe tener al menos 6 caracteres";
    }
    
    // Validar que tenga al menos una mayúscula
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return "Debe contener al menos una letra mayúscula";
    }
    
    // Validar que tenga al menos una minúscula
    if (!value.contains(RegExp(r'[a-z]'))) {
      return "Debe contener al menos una letra minúscula";
    }
    
    // Validar que tenga al menos un número
    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Debe contener al menos un número";
    }
    
    // Validar que tenga al menos un caracter especial
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Debe contener al menos un caracter especial (!@#\$%^&*(), etc.)";
    }
    
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icono superior
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: const Color.fromARGB(255, 25, 118, 248),
                          child: Icon(Icons.inventory_2_rounded, size: 38, color: Colors.white),
                        ),
                        const SizedBox(height: 18),
                        // Título
                        const Text(
                          "MetalStock Pro",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Subtítulo
                        const Text(
                          "Sistema de gestión de inventario de metales",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        // Formulario
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Email
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: "Correo electrónico",
                                  hintText: "usuario@empresa.com",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty || !value.contains('@')) {
                                    return "Ingresa un correo válido";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              // Contraseña
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: "Contraseña",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                validator: _isLogin ? 
                                  // Validación más simple para login
                                  (value) {
                                    if (value == null || value.isEmpty) {
                                      return "La contraseña es requerida";
                                    }
                                    return null;
                                  } 
                                  : 
                                  // Validación completa para registro
                                  _validatePassword,
                              ),
                              if (!_isLogin) ...[
                                const SizedBox(height: 12),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    'La contraseña debe contener:\n• Al menos 6 caracteres\n• Una mayúscula y una minúscula\n• Un número\n• Un carácter especial (!@#\$%^&*)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              // Botón de Login/Registro
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 25, 118, 248),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  onPressed: _isLoading ? null : _submit,
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : Text(_isLogin ? "Iniciar Sesión" : "Registrarse"),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Cambiar entre Login y Registro
                              TextButton(
                                onPressed: _isLoading ? null : () => setState(() => _isLogin = !_isLogin),
                                child: Text(
                                  _isLogin
                                      ? "¿No tienes cuenta? Regístrate"
                                      : "¿Ya tienes cuenta? Inicia sesión",
                                  style: const TextStyle(color: Color.fromARGB(255, 25, 118, 248)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}