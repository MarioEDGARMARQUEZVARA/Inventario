import 'package:flutter/material.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';
import 'package:inventario_proyecto/services/transformadores_service.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';
import 'package:inventario_proyecto/screens/transformadoresactuales_operations_screen.dart';

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
          return ListView.builder(
            itemCount: transformadores.length,
            itemBuilder: (context, index) {
              final t = Tranformadoresactuales.fromMap(transformadores[index]);
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransformadoresActualesOperationsScreen(transformador: t),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey[300],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TRANSFORMADOR ${t.consecutivo}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Estado: ${t.estado}',
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2196F3),
        onPressed: () {
       
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}