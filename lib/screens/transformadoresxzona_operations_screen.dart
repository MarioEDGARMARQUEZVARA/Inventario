import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/motivo.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_update.dart';
import 'package:inventario_proyecto/widgets/motivo_dialog.dart';

class TrasnformadoresxzonaOperationsScreen extends StatelessWidget {
  final TransformadoresXZona transformador;

  const TrasnformadoresxzonaOperationsScreen({super.key, required this.transformador});

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  String? _formatDateNullable(DateTime? date) {
    if (date == null) return null;
    if (date.year == 1900) return null;
    return _formatDate(date);
  }

  Future<List<Motivo>> _fetchMotivos(String docId) async {
    if (docId.isEmpty) return [];
    try {
      final snap = await FirebaseFirestore.instance
          .collection('Transformadoresxzona')
          .doc(docId)
          .collection('motivos')
          .orderBy('fecha', descending: true)
          .get();
      return snap.docs.map((d) => Motivo.fromMap(d.data(), id: d.id)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final fechaMov = _formatDateNullable(transformador.fechaMovimiento);

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
            if (transformador.zona.isNotEmpty) Text('Zona: ${transformador.zona}'),
            if (transformador.numEconomico != 0) Text('Número económico: ${transformador.numEconomico}'),
            if (transformador.marca.isNotEmpty) Text('Marca: ${transformador.marca}'),
            if (transformador.capacidad != 0) Text('Capacidad: ${transformador.capacidad}'),
            if (transformador.fase != 0) Text('Fase: ${transformador.fase}'),
            if (transformador.numeroDeSerie.isNotEmpty) Text('Número de serie: ${transformador.numeroDeSerie}'),
            if (transformador.litros.isNotEmpty) Text('Litros de aceite: ${transformador.litros}'),
            if (transformador.pesoKg.isNotEmpty) Text('Peso en kg: ${transformador.pesoKg}'),
            if (transformador.relacion != null && transformador.relacion != 0) Text('Relación: ${transformador.relacion}'),
            if (transformador.status.isNotEmpty) Text('Status: ${transformador.status}'),
            if (fechaMov != null) Text('Fecha de movimiento: $fechaMov'),
            Text('Reparado: ${transformador.reparado ? "Sí" : "No"}'),
            const SizedBox(height: 12),

            // Motivos (subcolección)
            FutureBuilder<List<Motivo>>(
              future: transformador.id != null ? _fetchMotivos(transformador.id!) : Future.value([]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox.shrink();
                final motivos = snapshot.data ?? [];
                if (motivos.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Motivos:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...motivos.map((m) {
                      final fecha = m.fecha != null ? '${m.fecha!.day.toString().padLeft(2,'0')}/${m.fecha!.month.toString().padLeft(2,'0')}/${m.fecha!.year}' : 'N/A';
                      return Text('- ${m.descripcion} (${fecha})');
                    }).toList(),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),

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
          ],
        ),
      ),
    );
  }
}

