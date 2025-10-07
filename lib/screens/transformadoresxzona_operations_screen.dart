import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_update.dart';
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
            Text('Fecha de movimiento: ${transformador.fechaMovimiento != null ? _formatDate(transformador.fechaMovimiento!) : "N/A"}'),
            Text('Reparado: ${transformador.reparado ? "Sí" : "No"}'),
            const SizedBox(height: 24),

            // Eliminar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  if (transformador.id != null) {
                    await deleteTransformadorZona(transformador.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transformador eliminado')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),

            // Actualizar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2A1AFF)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransformadoresxzonaUpdateScreen(transformador: transformador),
                    ),
                  );
                },
                child: const Text('Actualizar', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),

            // Exportar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {},
                child: const Text('Exportar a xlsx', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),

            // Enviar a mantenimiento
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                onPressed: () async {
                  if (transformador.id == null) return;
                  final motivo = await mostrarMotivoDialog(context);
                  if (motivo != null && motivo.isNotEmpty) {
                    await enviarAMantenimientoZona(transformador.id!, motivo);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enviado a mantenimiento')),
                    );
                    }
                },
                child: const Text('Enviar a mantenimiento', style: TextStyle(color: Colors.white)),
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

  Future<String?> obtenerMotivo(String id) async {
    // La colección de mantenimiento utilizada en los servicios es 'mantenimiento2025'
    final col = FirebaseFirestore.instance.collection('mantenimiento2025');
    final snapshot = await col
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

