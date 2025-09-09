import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/widgets/motivo_dialog.dart';


class TrasnformadoresxzonaOperationsScreen extends StatelessWidget {
  final TransformadoresXZona transformador;

  const TrasnformadoresxzonaOperationsScreen({super.key, required this.transformador});

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1AFF),
        title: const Text(
          'Transformadores en la zona',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Zona: ${transformador.zona}'),
            Text('Número económico: ${transformador.numEconomico}'),
            Text('Marca: ${transformador.marca}'),
            Text('Capacidad: ${transformador.capacidad}'),
            Text('Fase: ${transformador.fase}'),
            Text('Número de serie: ${transformador.numeroDeSerie}'),
            Text('Litros de aceite: ${transformador.litros}'),
            Text('Peso en kg: ${transformador.pesoKg}'),
            Text('Relación: ${transformador.relacion}'),
            Text('Status: ${transformador.status}'),
            Text('Fecha de movimiento: ${_formatDate(transformador.fechaMovimiento)}'),
            Text('Reparado: ${transformador.reparado ? "Sí" : "No"}'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {},
                child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2A1AFF)),
                onPressed: () {},
                child: const Text('Actualizar', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {},
                child: const Text('Exportar a xlsx', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () async {
                  if (transformador.id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error: El ID del transformador es nulo')),
                    );
                    return;
                  }
                  final motivo = await mostrarMotivoDialog(context);
                  if (motivo != null && motivo.isNotEmpty) {
                    // Actualiza campo reparado y guarda motivo
                    // await (transformador.id!, motivo); // <-- Elimina o implementa correctamente esta línea
                    await FirebaseFirestore.instance
                      .collection('Transformadoresxzona')
                      .doc(transformador.id)
                      .update({'reparado': true});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Marcado como reparado')),
                    );
                  }
                },
                child: const Text('Reparado', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<String?>(
              future: transformador.id != null ? obtenerMotivo(transformador.id!) : Future.value(null),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final motivo = snapshot.data;
                  return Text('Último motivo de mantenimiento: ${motivo ?? "No disponible"}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Ejemplo para mostrar el motivo en la pantalla de mantenimiento
  Future<String?> obtenerMotivo(String id) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Mantenimiento')
        .doc(id)
        .collection('motivos')
        .orderBy('fecha', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first['motivo'] as String?;
    }
    return null;
  }
}

