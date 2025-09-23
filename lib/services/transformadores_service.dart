import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Tranformadoresactuales>> getTranformadoresActuales() async {
  CollectionReference coleccion = db.collection("transformadores2025");
  QuerySnapshot queryTransformadoresActuales = await coleccion.get();
  return queryTransformadoresActuales.docs.map((e) {
    var transformadoractual = Tranformadoresactuales.fromMap(e.data() as Map<String, dynamic>);
    transformadoractual.id = e.id;
    return transformadoractual;
  }).toList();
}

Future<int> addTransformador(Tranformadoresactuales ta) async {
  CollectionReference coleccion = db.collection("transformadores2025");
  int code = 0;
  try {
    await coleccion.add(ta.toJson());
    code = 200;
  } catch (e) {
    code = 500;
  }
  return code;
}
Future<int> updateTransformador(Tranformadoresactuales ta) async {
  CollectionReference coleccion = db.collection('transformadores2025');
  int code = 0;
  try {
    await coleccion.doc(ta.id).set(ta.toJson());
    code = 200;
  } catch (e) {
    code = 500;
  }
  return code;
}
Future<int> deleteTransformadorActual(String id) async {
  CollectionReference coleccion = db.collection('transformadores2025');
  int code = 0;
  try {
    await coleccion.doc(id).delete();
    code = 200;
  } catch (e) {
    code = 500;
  }
  return code;
}
