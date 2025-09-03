import 'package:cloud_firestore/cloud_firestore.dart';

class MantenimientoService {
  final CollectionReference _mantenimientoRef =
      FirebaseFirestore.instance.collection('Mantenimiento');


  Stream<List<Map<String, dynamic>>> getMantenimientoStream() {
    return _mantenimientoRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }


  Future<List<Map<String, dynamic>>> getMantenimientoOnce() async {
    final snapshot = await _mantenimientoRef.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  
}
