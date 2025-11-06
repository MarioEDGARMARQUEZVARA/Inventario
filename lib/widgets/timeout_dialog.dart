import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class TimeoutDialog extends StatelessWidget {
  final VoidCallback? onDismiss;

  const TimeoutDialog({super.key, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);

    // 🔹 Redirigir automáticamente cuando el contador llegue a 0
    if (sessionProvider.countdownSeconds == 0 &&
        !sessionProvider.isSessionActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Cierra el diálogo
        }
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (route) => false); // Redirige al login
      });
    }

    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.timer, color: Colors.orange),
            SizedBox(width: 10),
            Text('Tiempo de inactividad'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Su sesión está a punto de expirar por inactividad.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'La sesión se cerrará en: ${sessionProvider.countdownSeconds} segundos',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '¿Desea extender su sesión?',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              sessionProvider.extendSession();
              if (onDismiss != null) onDismiss!();
              Navigator.of(context).pop();
            },
            child: const Text('Sí, mantener sesión'),
          ),
        ],
      ),
    );
  }
}
