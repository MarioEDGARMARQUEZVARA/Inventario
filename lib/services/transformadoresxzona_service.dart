import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<TransformadoresXZona>> getTransformadoresxZona() async {
  CollectionReference coleccion = db.collection("Transformadoresxzona");
  QuerySnapshot queryTransformadoresActuales = await coleccion.get();
  return queryTransformadoresActuales.docs.map((e) {
    var transformadoractual = TransformadoresXZona.fromMap(e.data() as Map<String, dynamic>);
    transformadoractual.id = e.id;
    return transformadoractual;
  }).toList();
}

Future<int> addTransformador(TransformadoresXZona tz) async {
  CollectionReference coleccion = db.collection("Transformadoresxzona");
  int code = 0;
  try {
    await coleccion.add(tz.toJson());
    code = 200;
  } catch (e) {
    code = 500;
  }
  return code;
}
Future<int> updateTransformador(TransformadoresXZona tz) async {
  CollectionReference coleccion = db.collection('Transformadoresxzona');
  int code = 0;
  try {
    await coleccion.doc(tz.id).set(tz.toJson());
    code = 200;
  } catch (e) {
    code = 500;
  }
  return code;
}
Future<int> deleteTransformadorActual(String id) async {
  CollectionReference coleccion = db.collection('Transformadoresxzona');
  int code = 0;
  try {
    await coleccion.doc(id).delete();
    code = 200;
  } catch (e) {
    code = 500;
  }
  return code;
}

Stream<List<TransformadoresXZona>> transformadoresxzonaStream() {
  return db.collection("Transformadoresxzona").snapshots().map((snapshot) =>
    snapshot.docs.map((doc) {
      var transformador = TransformadoresXZona.fromMap(doc.data() as Map<String, dynamic>);
      transformador.id = doc.id;
      return transformador;
    }).toList()
  );
}
