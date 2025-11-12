import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class InactivityDetector extends StatefulWidget {
  final Widget child;
  
  const InactivityDetector({
    super.key,
    required this.child,
  });

  @override
  State<InactivityDetector> createState() => _InactivityDetectorState();
}

class _InactivityDetectorState extends State<InactivityDetector> with WidgetsBindingObserver {
  final FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode.addListener(_handleFocusChange);
    _resetTimer();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      // Cuando el teclado está activo, resetear el timer
      final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      _resetTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    
    if (state == AppLifecycleState.resumed) {
      print('📱 App resumida - Reiniciando timer');
      sessionProvider.resumeTimer();
      _resetTimer();
    } else if (state == AppLifecycleState.paused) {
      print('📱 App pausada - Pausando timer');
      sessionProvider.pauseTimer();
    } else if (state == AppLifecycleState.inactive) {
      print('📱 App inactiva - Pausando timer');
      sessionProvider.pauseTimer();
    }
  }

  void _resetTimer() {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    
    // NO resetear si está en modo timeout (showTimeoutDialog = true)
    if (sessionProvider.showTimeoutDialog) {
      print('⏰ En modo timeout - No resetear timer');
      return;
    }
    
    // Solo resetear si no está pausado y la sesión está activa
    if (!sessionProvider.isPaused && sessionProvider.isSessionActive) {
      sessionProvider.resetInactivityTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      child: GestureDetector(
        onTap: _resetTimer,
        onPanUpdate: (_) => _resetTimer(),
        behavior: HitTestBehavior.translucent,
        child: Focus(
          focusNode: _focusNode,
          canRequestFocus: true,
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              _resetTimer();
            }
          },
          child: widget.child,
        ),
      ),
    );
  }
}