import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Mantenimiento>> getMantenimientos() async {
  CollectionReference coleccion = db.collection("Mantenimiento");
  QuerySnapshot queryMantenimientos = await coleccion.get();
  return queryMantenimientos.docs.map((e) {
    var mantenimiento = Mantenimiento.fromMap(e.data() as Map<String, dynamic>);
    mantenimiento.id = e.id;
    return mantenimiento;
  }).toList();
}

Future<int> addMantenimiento(Mantenimiento m) async {
  CollectionReference coleccion = db.collection("Mantenimiento");
  int code = 0;
  try {
    await coleccion.add(m.toJson());
    code = 200;
  } catch (e) {
    code = 500;
  }
  return code;
}
Future<int> updateMantenimiento(Mantenimiento m) async {
  CollectionReference coleccion = db.collection('Mantenimiento');
  int code = 0;
  try {
    await coleccion.doc(m.id).set(m.toJson());
    code = 200;
  } catch (e) {
    code = 500;
  }
  return code;
}
Future<int> deleteMantenimiento(String id) async {
  CollectionReference coleccion = db.collection('Mantenimiento');
  int code = 0;
  try {
    await coleccion.doc(id).delete();
    code = 200;
  } catch (e) {
    code = 500;
  }
  return code;
}
Stream<List<Mantenimiento>> mantenimientosStream() {
  return db.collection("Mantenimiento").snapshots().map((snapshot) =>
    snapshot.docs.map((doc) {
      var mantenimiento = Mantenimiento.fromMap(doc.data() as Map<String, dynamic>);
      mantenimiento.id = doc.id;
      return mantenimiento;
    }).toList()
  );
}
