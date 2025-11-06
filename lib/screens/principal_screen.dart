import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventario_proyecto/screens/mantenimiento_screen.dart';
import 'package:inventario_proyecto/screens/transformadores2025_screen.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_screen.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  @override
  void initState() {
    super.initState();
    // Iniciar el timer de inactividad cuando se carga la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      sessionProvider.startSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final sessionProvider = Provider.of<SessionProvider>(context);
    
    String userName = user?.email != null ? user!.email!.split('@')[0].toUpperCase() : 'USER';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: sessionProvider.showTimeoutDialog 
            ? Colors.orange 
            : const Color.fromARGB(255, 42, 26, 255),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Menú Principal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        // Mostrar icono de advertencia cuando está activo el timeout
        actions: [
          if (sessionProvider.showTimeoutDialog)
            IconButton(
              icon: const Icon(Icons.warning, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            Text(
              'Bienvenido, $userName',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              '¿A donde quiere ir?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Aviso visual cuando está activo el timeout
            if (sessionProvider.showTimeoutDialog) ...[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 30),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '¡Sesión por expirar!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Tiempo restante: ${sessionProvider.countdownSeconds} segundos',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.open_in_new, color: Colors.orange),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            // Botón 1
            SizedBox(
              width: 260,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 150, 243),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: sessionProvider.showTimeoutDialog 
                    ? null 
                    : () {
                        sessionProvider.resetTimer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Transformadores2025Screen()),
                        );
                      },
                child: const Text('Transformadores 2025'),
              ),
            ),
            const SizedBox(height: 20),
            
            // Botón 2
            SizedBox(
              width: 260,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 29, 233, 182),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: sessionProvider.showTimeoutDialog 
                    ? null 
                    : () {
                        sessionProvider.resetTimer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MantenimientoScreen()),
                        );
                      },
                child: const Text('Mantenimiento'),
              ),
            ),
            const SizedBox(height: 20),
            
            // Botón 3
            SizedBox(
              width: 260,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 101, 31, 255),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: sessionProvider.showTimeoutDialog 
                    ? null 
                    : () {
                        sessionProvider.resetTimer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TransformadoresxzonaScreen()),
                        );
                      },
                child: const Text('Transformadores en la zona'),
              ),
            ),
            const SizedBox(height: 32),
            
            // Botón cerrar sesión
            SizedBox(
              width: 180,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: sessionProvider.showTimeoutDialog 
                    ? null 
                    : () async {
                        final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
                        sessionProvider.forceLogout();
                      },
                child: const Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
      
      // Floating Action Button para abrir el drawer fácilmente durante timeout
      floatingActionButton: sessionProvider.showTimeoutDialog
          ? FloatingActionButton(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Icon(Icons.warning),
            )
          : null,
    );
  }
}