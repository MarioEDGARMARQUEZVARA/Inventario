import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionProvider extends ChangeNotifier {
  Timer? _inactivityTimer;
  Timer? _countdownTimer;
  int _countdownSeconds = 0;
  bool _showTimeoutDialog = false;
  bool _isSessionActive = true;
  bool _isDisposed = false;

  // NavigatorKey para navegación global
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Tiempo máximo de inactividad antes de mostrar el diálogo (en segundos)
  final int _inactivityLimit = 300; // 5 minutos

  int get countdownSeconds => _countdownSeconds;
  bool get showTimeoutDialog => _showTimeoutDialog;
  bool get isSessionActive => _isSessionActive;

  /// Inicia la sesión y el temporizador de inactividad
  void startSession() {
    if (_isDisposed) return;
    _isSessionActive = true;
    _showTimeoutDialog = false;
    _countdownSeconds = 0;
    notifyListeners();
    _startInactivityTimer();
  }

  /// Inicia el temporizador de inactividad
  void _startInactivityTimer() {
    if (_isDisposed) return;
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(Duration(seconds: _inactivityLimit), _onInactivityDetected);
    print('🔄 Timer de inactividad iniciado: $_inactivityLimit segundos (5 minutos)');
  }

  /// Reinicia el temporizador de inactividad cuando el usuario interactúa
  void resetTimer() {
    if (_isDisposed || !_isSessionActive || _showTimeoutDialog) return;
    _startInactivityTimer();
    print('🔄 Timer reiniciado por actividad del usuario');
  }

  /// Método compatible con versiones previas
  void resetInactivityTimer() => resetTimer();

  /// Detiene completamente el temporizador de sesión
  void stopTimer() {
    _inactivityTimer?.cancel();
    _countdownTimer?.cancel();
  }

  /// Cuando se detecta inactividad, inicia el conteo regresivo antes de cerrar sesión
  void _onInactivityDetected() {
    if (_isDisposed || !_isSessionActive) return;

    print('⏰ Inactividad detectada después de 5 minutos - Mostrando aviso...');
    _showTimeoutDialog = true;
    _countdownSeconds = 15; // 15 segundos para cerrar sesión automáticamente
    notifyListeners();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (_countdownSeconds > 0) {
        _countdownSeconds--;
        print('⏳ Countdown: $_countdownSeconds segundos');
        notifyListeners();
      } else {
        timer.cancel();
        print('🚪 Cerrando sesión por inactividad...');
        _logout();
      }
    });
  }

  /// Extiende la sesión del usuario si decide continuar
  void extendSession() {
    if (_isDisposed) return;
    print('✅ Sesión extendida por el usuario');
    _showTimeoutDialog = false;
    _countdownTimer?.cancel();
    _countdownSeconds = 0;
    notifyListeners();
    _startInactivityTimer();
  }

  /// Cierra la sesión automáticamente
  void _logout() async {
    if (_isDisposed) return;

    print('🔒 Cerrando sesión...');
    _isSessionActive = false;
    _showTimeoutDialog = false;
    _countdownTimer?.cancel();
    _countdownSeconds = 0;
    notifyListeners();

    try {
      // Cerrar sesión en Firebase
      await FirebaseAuth.instance.signOut();
      print('✅ Sesión cerrada en Firebase');

      // Navegar a la pantalla de inicio de sesión
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isDisposed) return;
        
        // Usar NavigatorKey para navegar de manera global
        if (navigatorKey.currentState != null && navigatorKey.currentState!.mounted) {
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            '/', 
            (route) => false
          );
          print('✅ Navegación a pantalla de inicio completada');
        }
      });
    } catch (e) {
      print('❌ Error al cerrar sesión: $e');
    }
  }

  /// Método para forzar cierre de sesión manualmente
  void forceLogout() async {
    if (_isDisposed) return;
    
    _isSessionActive = false;
    _showTimeoutDialog = false;
    _countdownTimer?.cancel();
    _countdownSeconds = 0;
    _inactivityTimer?.cancel();
    
    notifyListeners();

    try {
      await FirebaseAuth.instance.signOut();
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isDisposed) return;
        if (navigatorKey.currentState != null && navigatorKey.currentState!.mounted) {
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            '/', 
            (route) => false
          );
        }
      });
    } catch (e) {
      print('❌ Error al forzar cierre de sesión: $e');
    }
  }

  /// Limpia todos los recursos correctamente
  @override
  void dispose() {
    _isDisposed = true;
    _inactivityTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
}