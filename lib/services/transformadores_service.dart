import 'package:cloud_firestore/cloud_firestore.dart';

class TransformadoresService {
  final CollectionReference _transformadoresRef =
      FirebaseFirestore.instance.collection('transformadores2025');


  Stream<List<Map<String, dynamic>>> getTransformadoresStream() {
    return _transformadoresRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }


  Future<List<Map<String, dynamic>>> getTransformadoresOnce() async {
    final snapshot = await _transformadoresRef.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  
}
