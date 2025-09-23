import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_operations_screen.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_add_screen.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';

class TransformadoresxzonaMembersScreen extends StatelessWidget {
  final String zona;

  const TransformadoresxzonaMembersScreen({
    super.key,
    required this.zona,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1AFF),
        title: Text(
          'ZONA: ${zona.toUpperCase()}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: StreamBuilder<List<TransformadoresXZona>>(
              stream: transformadoresxzonaStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                // Filtra por zona aquí
                final transformadores = (snapshot.data ?? [])
                    .where((t) => t.zona == zona)
                    .toList();
                if (transformadores.isEmpty) {
                  return const Center(child: Text('No hay transformadores registrados en esta zona.'));
                }
                return ListView.builder(
                  itemCount: transformadores.length,
                  itemBuilder: (context, index) {
                    final t = transformadores[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TrasnformadoresxzonaOperationsScreen(transformador: t),
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
                              t.numeroDeSerie,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'Reparado: ${t.reparado ? "Sí" : "No"}',
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
              builder: (_) => TransformadoresxzonaAddScreen(zona: zona),
            ),
          );
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}

