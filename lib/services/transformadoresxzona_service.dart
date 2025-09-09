import 'package:cloud_firestore/cloud_firestore.dart';

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
}