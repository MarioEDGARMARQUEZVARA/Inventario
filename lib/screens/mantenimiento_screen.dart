import 'package:flutter/material.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:inventario_proyecto/screens/mantenimiento_operations_screen.dart';
import 'package:inventario_proyecto/screens/mantenimiento_add_screen.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';

class MantenimientoScreen extends StatefulWidget {
  const MantenimientoScreen({super.key});

  @override
  State<MantenimientoScreen> createState() => _MantenimientoScreenState();
}

class _MantenimientoScreenState extends State<MantenimientoScreen> {
  final MantenimientoService _service = MantenimientoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1AFF),
        title: const Text(
          'Mantenimiento',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _service.getMantenimientoStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: [${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No hay reportes de mantenimiento registrados.'));
          }
          final mantenimientos = data.map((e) => Mantenimiento.fromMap(e)).toList();
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: mantenimientos.length,
                  itemBuilder: (context, index) {
                    final m = mantenimientos[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          m.numero_mantenimiento.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          'Estado: ${m.estado}',
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MantenimientoOperationsScreen(mantenimiento: m),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MantenimientoAddScreen()),
          );
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
