import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';

class TransformadoresxzonaService {
  final CollectionReference _transformadoresxzonaRef =
      FirebaseFirestore.instance.collection('Transformadoresxzona');

  Stream<List<Map<String, dynamic>>> getTransformadoresxzonaStream() {
    return _transformadoresxzonaRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Asegurar que el ID esté incluido
          return data;
        }).toList());
  }

  Future<List<Map<String, dynamic>>> getTransformadoresxzonaOnce() async {
    final snapshot = await _transformadoresxzonaRef.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Asegurar que el ID esté incluido
      return data;
    }).toList();
  }

  Future<void> agregarMotivoTransformadorXZona(String id, String motivo) async {
    await FirebaseFirestore.instance
        .collection('Transformadoresxzona')
        .doc(id)
        .collection('Motivos')
        .add({'Motivo': motivo, 'fecha': DateTime.now()});
  }

  Future<void> agregarTransformadorXZona(TransformadoresXZona transformador) async {
    await _transformadoresxzonaRef.add({
      'Zona': transformador.zona,
      'Numero_economico': transformador.numEconomico,
      'Marca': transformador.marca,
      'Capacidad': transformador.capacidad,
      'Fase': transformador.fase,
      'Numero_de_serie': transformador.numeroDeSerie,
      'Litros': transformador.litros,
      'Peso_kg': transformador.pesoKg,
      'Relacion': transformador.relacion,
      'Status': transformador.status,
      'Fecha_mov': transformador.fechaMovimiento.toIso8601String(),
      'Reparado': transformador.reparado,
      // 'Motivo': transformador.motivo, // opcional
    });
  }
}