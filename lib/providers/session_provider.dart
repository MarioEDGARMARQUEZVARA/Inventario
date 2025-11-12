import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionProvider extends ChangeNotifier {
  Timer? _inactivityTimer;
  Timer? _countdownTimer;
  int _countdownSeconds = 0;
  bool _showTimeoutDialog = false;
  bool _isSessionActive = false; // Iniciar como false
  bool _isDisposed = false;
  bool _isPaused = false;
  DateTime? _lastActivityTime;
  
  // Control para evitar múltiples timers
  bool _timerRunning = false;
  bool _countdownRunning = false;

  // NavigatorKey para navegación global
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Tiempo máximo de inactividad antes de mostrar el diálogo (en segundos)
  final int _inactivityLimit = 1800; // 30 minutos

  int get countdownSeconds => _countdownSeconds;
  bool get showTimeoutDialog => _showTimeoutDialog;
  bool get isSessionActive => _isSessionActive;
  bool get isPaused => _isPaused;

  /// Pausar el timer (durante loading, etc.)
  void pauseTimer() {
    if (_isDisposed) return;
    _isPaused = true;
    _stopAllTimers();
    print('⏸️ Timer pausado');
  }

  /// Reanudar el timer
  void resumeTimer() {
    if (_isDisposed || !_isSessionActive) return;
    _isPaused = false;
    _startInactivityTimer();
    print('▶️ Timer reanudado');
  }

  /// Detener todos los timers
  void _stopAllTimers() {
    if (_inactivityTimer != null) {
      _inactivityTimer?.cancel();
      _inactivityTimer = null;
      _timerRunning = false;
    }
    
    if (_countdownTimer != null) {
      _countdownTimer?.cancel();
      _countdownTimer = null;
      _countdownRunning = false;
    }
  }

  /// Inicia la sesión y el temporizador de inactividad
  void startSession() {
    if (_isDisposed || _isSessionActive) return; // No iniciar si ya está activa
    
    print('🚀 INICIANDO SESIÓN - Timer principal');
    _isSessionActive = true;
    _isPaused = false;
    _showTimeoutDialog = false;
    _countdownSeconds = 0;
    _lastActivityTime = DateTime.now();
    notifyListeners();
    _startInactivityTimer();
  }

  /// Inicia el temporizador de inactividad
  void _startInactivityTimer() {
    if (_isDisposed || _isPaused || !_isSessionActive || _timerRunning) return;
    
    _stopAllTimers(); // Asegurar que no hay timers corriendo
    
    _inactivityTimer = Timer(Duration(seconds: _inactivityLimit), _onInactivityDetected);
    _timerRunning = true;
    print('🔄 Timer de inactividad iniciado: $_inactivityLimit segundos (30 minutos)');
  }

  /// Reinicia el temporizador de inactividad cuando el usuario interactúa
  void resetTimer() {
    if (_isDisposed || !_isSessionActive || _showTimeoutDialog || _isPaused) return;
    
    _lastActivityTime = DateTime.now();
    _startInactivityTimer();
    print('🔄 Timer reiniciado por actividad del usuario');
  }

  /// Método compatible con versiones previas
  void resetInactivityTimer() => resetTimer();

  /// Detiene completamente el temporizador de sesión
  void stopTimer() {
    _stopAllTimers();
    print('🛑 Timer detenido manualmente');
  }

  /// Cuando se detecta inactividad, inicia el conteo regresivo antes de cerrar sesión
  void _onInactivityDetected() {
    if (_isDisposed || !_isSessionActive || _isPaused || _countdownRunning) return;

    print('⏰ Inactividad detectada después de 30 minutos - Mostrando aviso...');
    _showTimeoutDialog = true;
    _countdownSeconds = 15; // 15 segundos para cerrar sesión automáticamente
    _timerRunning = false;
    notifyListeners();

    _startCountdownTimer();
  }

  /// Inicia el contador regresivo
  void _startCountdownTimer() {
    if (_countdownRunning) return;
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed || _isPaused) {
        timer.cancel();
        _countdownRunning = false;
        return;
      }

      if (_countdownSeconds > 0) {
        _countdownSeconds--;
        print('⏳ Countdown: $_countdownSeconds segundos');
        notifyListeners();
      } else {
        timer.cancel();
        _countdownRunning = false;
        print('🚪 Cerrando sesión por inactividad...');
        _logout();
      }
    });
    _countdownRunning = true;
  }

  /// Extiende la sesión del usuario si decide continuar
  void extendSession() {
    if (_isDisposed) return;
    print('✅ Sesión extendida por el usuario');
    
    // DETENER TODOS LOS TIMERS PRIMERO
    _stopAllTimers();
    
    _showTimeoutDialog = false;
    _countdownSeconds = 0;
    _isPaused = false;
    _lastActivityTime = DateTime.now();
    
    notifyListeners();
    
    // REINICIAR EL TIMER DE INACTIVIDAD
    _startInactivityTimer();
  }

  /// Método seguro para extender sesión desde UI
  void extendSessionFromUI(BuildContext context) {
    if (_isDisposed) return;
    
    print('🔄 Extendiendo sesión desde UI...');
    
    // Cerrar el drawer primero si está abierto
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    // Extender la sesión
    extendSession();

    // Mostrar mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sesión extendida exitosamente'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Cierra la sesión automáticamente
  void _logout() async {
    if (_isDisposed) return;

    print('🔒 Cerrando sesión...');
    _isSessionActive = false;
    _showTimeoutDialog = false;
    
    // DETENER TODOS LOS TIMERS
    _stopAllTimers();
    
    _countdownSeconds = 0;
    _isPaused = false;
    notifyListeners();

    try {
      await FirebaseAuth.instance.signOut();
      print('✅ Sesión cerrada en Firebase');

      // Usar navigatorKey en lugar de context para evitar errores
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isDisposed) return;
        
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
    
    print('🔒 Cierre de sesión manual forzado');
    _isSessionActive = false;
    _showTimeoutDialog = false;
    
    // DETENER TODOS LOS TIMERS
    _stopAllTimers();
    
    _countdownSeconds = 0;
    _isPaused = false;
    
    notifyListeners();

    try {
      await FirebaseAuth.instance.signOut();
      print('✅ Sesión cerrada correctamente en Firebase');
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isDisposed) return;
        if (navigatorKey.currentState != null && navigatorKey.currentState!.mounted) {
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            '/', 
            (route) => false
          );
          print('✅ Redirección a login completada');
        }
      });
    } catch (e) {
      print('❌ Error al forzar cierre de sesión: $e');
    }
  }

  /// Cerrar sesión manualmente desde el drawer - VERSIÓN SEGURA
  Future<void> manualLogout() async {
    if (_isDisposed) return;
    
    print('🔒 Cierre de sesión manual iniciado');
    
    // Detener todos los timers inmediatamente
    _isSessionActive = false;
    _showTimeoutDialog = false;
    
    // DETENER TODOS LOS TIMERS
    _stopAllTimers();
    
    _countdownSeconds = 0;
    _isPaused = false;
    
    notifyListeners();

    try {
      // Cerrar sesión en Firebase
      await FirebaseAuth.instance.signOut();
      print('✅ Sesión cerrada correctamente');

      // Navegar al login usando navigatorKey (más seguro que context)
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
      print('❌ Error al cerrar sesión manualmente: $e');
    }
  }

  /// Método simplificado para cerrar sesión desde UI
  Future<void> logoutFromUI(BuildContext context) async {
    // Cerrar el drawer primero si está abierto
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    // Mostrar mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cerrando sesión...'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );

    // Pequeña pausa para mostrar el mensaje
    await Future.delayed(const Duration(milliseconds: 500));

    // Ejecutar el logout seguro
    await manualLogout();
  }

  /// Limpia todos los recursos correctamente
  @override
  void dispose() {
    _isDisposed = true;
    _stopAllTimers();
    super.dispose();
  }
}