import 'package:flutter/material.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_members_screen.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_add_screen.dart';

class TransformadoresxzonaScreen extends StatefulWidget {
  const TransformadoresxzonaScreen({super.key});

  @override
  State<TransformadoresxzonaScreen> createState() => _TransformadoresxzonaScreenState();
}

class _TransformadoresxzonaScreenState extends State<TransformadoresxzonaScreen> {
  final TransformadoresxzonaService _service = TransformadoresxzonaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1AFF),
        title: const Text(
          'Transformadores en la zona',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Tu lista y contenido principal
          Padding(
            padding: const EdgeInsets.only(bottom: 100), // deja espacio para el botón
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _service.getTransformadoresxzonaStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final data = snapshot.data ?? [];
                if (data.isEmpty) {
                  return const Center(child: Text('No hay transformadores registrados.'));
                }

                // Agrupar por zona
                final Map<String, List<TransformadoresXZona>> zonas = {};
                for (var item in data) {
                  final t = TransformadoresXZona.fromMap(item);
                  zonas.putIfAbsent(t.zona, () => []).add(t);
                }

                final zonaKeys = zonas.keys.toList();

                return ListView.builder(
                  itemCount: zonaKeys.length,
                  itemBuilder: (context, index) {
                    final zona = zonaKeys[index];
                    final cantidad = zonas[zona]!.length;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TransformadoresxzonaMembersScreen(
                              zona: zona,
                              transformadores: zonas[zona]!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey[300],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              zona.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'Cantidad: $cantidad',
                              style: const TextStyle(color: Colors.black54, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Botón exportar centrado abajo
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Aquí va la lógica para exportar a xlsx
                  },
                  child: const Text(
                    'Exportar a xlsx',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2196F3),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TransformadoresxzonaAddScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}