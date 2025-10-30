import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/motivo.dart';

class MotivosList extends StatelessWidget {
  final String collectionPath; // e.g. 'mantenimiento2025' o 'transformadores2025'
  final String docId;
  final String fechaCampo; // normalmente 'fecha' o el campo que uses para ordenar

  const MotivosList({
    super.key,
    required this.collectionPath,
    required this.docId,
    this.fechaCampo = 'fecha',
  });

  Future<List<Motivo>> _fetchMotivos() async {
    if (docId.isEmpty) return [];
    try {
      final snap = await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(docId)
          .collection('motivos')
          .orderBy(fechaCampo, descending: true)
          .get();
      return snap.docs.map((d) => Motivo.fromMap(d.data(), id: d.id)).toList();
    } catch (_) {
      return [];
    }
  }

  String _formatFecha(DateTime? f) {
    if (f == null) return 'N/A';
    return '${f.day.toString().padLeft(2,'0')}/${f.month.toString().padLeft(2,'0')}/${f.year}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Motivo>>(
      future: _fetchMotivos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox.shrink();
        final motivos = snapshot.data ?? [];
        if (motivos.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text('Motivos:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...motivos.map((m) {
              final fecha = m.fecha != null ? _formatFecha(m.fecha) : 'N/A';
              return Text('- ${m.descripcion} (${fecha})');
            }).toList(),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

