import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/motivo.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_update.dart';
import 'package:inventario_proyecto/widgets/motivo_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/transformadoresxzona_provider.dart';
import 'package:inventario_proyecto/widgets/eliminar_dialog.dart';

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
    final provider = Provider.of<TransformadoresxZonaProvider>(context, listen: false);

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
            if (transformador.economico != 0) Text('Económico: ${transformador.economico}'),
            if (transformador.marca.isNotEmpty) Text('Marca: ${transformador.marca}'),
            if (transformador.capacidadKVA != 0) Text('capacidadKVA: ${transformador.capacidadKVA}'),
            if (transformador.fases != 0) Text('Fase: ${transformador.fases}'),
            if (transformador.serie.isNotEmpty) Text('Número de serie: ${transformador.serie}'),
            if (transformador.aceite.isNotEmpty) Text('Litros de aceite: ${transformador.aceite}'),
            if (transformador.peso_placa_de_datos.isNotEmpty) Text('Peso en kg: ${transformador.peso_placa_de_datos}'),
            if (transformador.relacion != null && transformador.relacion != 0) Text('Relación: ${transformador.relacion}'),
            if (transformador.estado.isNotEmpty) Text('Status: ${transformador.estado}'),
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
                  final confirmar = await eliminarDialog(context);
                  if (confirmar == true && transformador.id != null) {
                    await provider.deleteTransformadorProvider(transformador.id!);
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
                  ).then((_) {
                    // Actualizar datos después de regresar de la actualización
                    provider.refreshData(transformador.id!);
                  });
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
                onPressed: () {
                  exportTransformadoresxzonaToExcel(context);
                },
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
                    final result = await provider.enviarAMantenimientoProvider(transformador.id!, motivo);
                    if (result == 200) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enviado a mantenimiento')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error al enviar a mantenimiento')),
                      );
                    }
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