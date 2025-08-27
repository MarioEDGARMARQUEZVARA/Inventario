import 'package:flutter/material.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';
import 'package:inventario_proyecto/services/transformadores_service.dart';

class Transformadores2025Screen extends StatefulWidget {
  const Transformadores2025Screen({super.key});

  @override
  State<Transformadores2025Screen> createState() => _Transformadores2025ScreenState();
}

class _Transformadores2025ScreenState extends State<Transformadores2025Screen> {
  final TransformadoresService _service = TransformadoresService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1AFF),
        title: const Text(
          'Transformadores 2025',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _service.getTransformadoresStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final transformadores = snapshot.data ?? [];
          if (transformadores.isEmpty) {
            return const Center(child: Text('No hay transformadores registrados.'));
          }
          return Column(
            children: [
              // Encabezado de lista (primer transformador)
              Container(
                color: Colors.grey[300],
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transformadores[0]['nombre'] ?? 'Sin nombre',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Estado: ${transformadores[0]['estado'] ?? 'Desconocido'}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Lista de transformadores (si hay más de uno)
              Expanded(
                child: ListView.builder(
                  itemCount: transformadores.length > 1 ? transformadores.length - 1 : 0,
                  itemBuilder: (context, index) {
                    final t = transformadores[index + 1];
                    return ListTile(
                      title: Text(
                        t['nombre'] ?? 'Sin nombre',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Estado: ${t['estado'] ?? 'Desconocido'}'),
                    );
                  },
                ),
              ),
              // Botón exportar
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SizedBox(
                  width: 250,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      
                    },
                    child: const Text(
                      'Exportar a xlsx',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2196F3),
        onPressed: () {
       
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}