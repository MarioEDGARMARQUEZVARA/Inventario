import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// Obtener lista de transformadores por zona
Future<List<TransformadoresXZona>> getTransformadoresxZona() async {
  QuerySnapshot query = await db.collection("Transformadoresxzona").get();
  return query.docs.map((doc) {
    // Debug: mostrar estructura real del documento antes del fromMap
    try {
      final raw = doc.data();
      print('getTransformadoresxZona doc.id=${doc.id} data=$raw');
      final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
      var transformador = TransformadoresXZona.fromMap(data);
      transformador.id = doc.id;
      return transformador;
    } catch (e) {
      print('getTransformadoresxZona parse error for doc ${doc.id}: $e');
      return TransformadoresXZona(
        id: doc.id,
        zona: '',
        numEconomico: 0,
        marca: '',
        capacidad: 0,
        fase: 0,
        numeroDeSerie: '',
        litros: '',
        pesoKg: '',
        relacion: 0,
        status: '',
        fechaMovimiento: null,
        reparado: false,
      );
    }
  }).toList();
}

/// Enviar transformador a mantenimiento con motivo
Future<int> enviarAMantenimientoZona(String id, String motivo) async {
  int code = 0;
  try {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await db.collection("Transformadoresxzona").doc(id).get();

    if (doc.exists) {
      Map<String, dynamic>? data = doc.data();

      // Guardamos también el origen
      data!["origen"] = "Transformadoresxzona";

      DocumentReference newDoc =
          await db.collection("mantenimiento2025").add(data);

      await newDoc.collection("motivos").add({
        "motivo": motivo,
        "fecha": FieldValue.serverTimestamp(), // <-- CORRECTO
      });

      await db.collection("Transformadoresxzona").doc(id).delete();

      code = 200;
    } else {
      code = 404;
    }
  } catch (e) {
    code = 500;
  }
  return code;
}

/// CRUD
Future<int> addTransformador(TransformadoresXZona tz) async {
  try {
    await db.collection("Transformadoresxzona").add(tz.toJson());
    return 200;
  } catch (_) {
    return 500;
  }
}

Future<int> updateTransformador(TransformadoresXZona tz) async {
  try {
    await db.collection('Transformadoresxzona').doc(tz.id).set(tz.toJson());
    return 200;
  } catch (_) {
    return 500;
  }
}

Future<int> deleteTransformadorZona(String id) async {
  try {
    await db.collection('Transformadoresxzona').doc(id).delete();
    return 200;
  } catch (_) {
    return 500;
  }
}

/// Stream
Stream<List<TransformadoresXZona>> transformadoresxzonaStream() {
  return db.collection("Transformadoresxzona").snapshots().map((snapshot) =>
      snapshot.docs.map((doc) {
        try {
          final raw = doc.data();
          print('transformadoresxzonaStream doc.id=${doc.id} data=$raw');
          final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
          var transformador = TransformadoresXZona.fromMap(data);
          transformador.id = doc.id;
          return transformador;
        } catch (e) {
          print('transformadoresxzonaStream parse error for doc ${doc.id}: $e');
          return TransformadoresXZona(
            id: doc.id,
            zona: '',
            numEconomico: 0,
            marca: '',
            capacidad: 0,
            fase: 0,
            numeroDeSerie: '',
            litros: '',
            pesoKg: '',
            relacion: 0,
            status: '',
            fechaMovimiento: null,
            reparado: false,
          );
        }
      }).toList());
}
