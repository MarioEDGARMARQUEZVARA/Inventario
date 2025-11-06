import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventario_proyecto/screens/transformadores2025_screen.dart';
import 'package:inventario_proyecto/screens/mantenimiento_screen.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_screen.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final sessionProvider = Provider.of<SessionProvider>(context, listen: true);

    // Si está en modo timeout, mostrar el drawer especial
    if (sessionProvider.showTimeoutDialog) {
      return _buildTimeoutDrawer(context, sessionProvider);
    }

    // Drawer normal
    return _buildNormalDrawer(context, user);
  }

  // Drawer normal para sesión activa
  Widget _buildNormalDrawer(BuildContext context, User? user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF2A1AFF),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.account_circle, size: 48, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  user?.email ?? 'Usuario',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Consumer<SessionProvider>(
                  builder: (context, session, _) {
                    return Text(
                      'Sesión activa',
                      style: TextStyle(
                        color: Colors.green[100],
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.electric_bolt, color: Color(0xFF2196F3)),
            title: const Text('Transformadores 2025'),
            onTap: () {
              Provider.of<SessionProvider>(context, listen: false).resetTimer();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Transformadores2025Screen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.build, color: Color(0xFF1DE9B6)),
            title: const Text('Mantenimiento'),
            onTap: () {
              Provider.of<SessionProvider>(context, listen: false).resetTimer();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MantenimientoScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.map, color: Color(0xFF651FFF)),
            title: const Text('Transformadores en la zona'),
            onTap: () {
              Provider.of<SessionProvider>(context, listen: false).resetTimer();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransformadoresxzonaScreen()),
              );
            },
          ),
          const Divider(),
          // Botón para extender sesión manualmente
          ListTile(
            leading: const Icon(Icons.timer, color: Colors.orange),
            title: const Text('Extender sesión'),
            onTap: () {
              final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
              sessionProvider.resetTimer();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesión extendida'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  // Drawer especial para el timeout
  Widget _buildTimeoutDrawer(BuildContext context, SessionProvider sessionProvider) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.orange,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  'TIEMPO DE INACTIVIDAD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  '${sessionProvider.countdownSeconds} segundos',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.warning, color: Colors.orange),
                  title: const Text('Sesión a punto de expirar'),
                  subtitle: const Text('Por inactividad prolongada'),
                  onTap: () {
                    // No hacer nada, solo informativo
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.blue),
                  title: const Text('¿Qué está pasando?'),
                  subtitle: const Text('No se detectó actividad por 5 minutos'),
                  onTap: () {
                    // Información adicional
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Cerrar sesión ahora'),
                  onTap: () {
                    Navigator.pop(context);
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
          ),
          // Botón para extender sesión en la parte inferior
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange[50],
            child: Column(
              children: [
                const Text(
                  '¿Desea continuar con su sesión?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      sessionProvider.extendSession();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sesión extendida exitosamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text(
                      'EXTENDER SESIÓN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}