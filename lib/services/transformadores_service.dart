import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// Obtener lista de transformadores actuales
Future<List<Tranformadoresactuales>> getTranformadoresActuales() async {
  CollectionReference coleccion = db.collection("transformadores2025");
  QuerySnapshot queryTransformadores = await coleccion.get();
  return queryTransformadores.docs.map((doc) {
    try {
      final raw = doc.data();
      print('getTranformadoresActuales doc.id=${doc.id} data=$raw');
      final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
      var transformador = Tranformadoresactuales.fromMap(data);
      transformador.id = doc.id;
      return transformador;
    } catch (e) {
      print('getTranformadoresActuales parse error for doc ${doc.id}: $e');
      return Tranformadoresactuales(
        area: '',
        consecutivo: 0,
        fecha_de_llegada: DateTime(1900),
        mes: '',
        marca: '',
        aceite: '',
        economico: '',
        capacidadKVA: 0,
        fases: 0,
        serie: '',
        peso_placa_de_datos: '',
        fecha_fabricacion: DateTime(1900),
        fecha_prueba: DateTime(1900),
        valor_prueba_1: '',
        valor_prueba_2: '',
        valor_prueba_3: '',
        resistencia_aislamiento_megaoms: 0,
        rigidez_dielecrica_kv: '',
        estado: '',
        fecha_de_entrada_al_taller: DateTime(1900),
        fecha_de_salida_del_taller: DateTime(1900),
        fecha_entrega_almacen: DateTime(1900),
        salida_mantenimiento: false,
        fecha_salida_mantenimiento: null,
        baja: '',
        cargas: 0,
        area_fecha_de_entrega_transformador_reparado: '',
      );
    }
  }).toList();
}

/// Enviar transformador a mantenimiento con motivo
Future<int> enviarAMantenimiento(String id, String motivo) async {
  int code = 0;
  try {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await db.collection("transformadores2025").doc(id).get();

    if (doc.exists) {
      Map<String, dynamic>? data = doc.data();

      // Guardamos también el origen
      data!["origen"] = "transformadores2025";

      // Copiar registro a mantenimiento
      DocumentReference newDoc =
          await db.collection("mantenimiento2025").add(data);

      // Guardar motivo como subcolección
      await newDoc.collection("motivos").add({
        "motivo": motivo,
        "fecha": DateTime.now(),
      });

      // Eliminar de transformadores actuales
      await db.collection("transformadores2025").doc(id).delete();

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
Future<int> addTransformador(Tranformadoresactuales ta) async {
  try {
    await db.collection("transformadores2025").add(ta.toJson());
    return 200;
  } catch (_) {
    return 500;
  }
}

Future<int> updateTransformador(Tranformadoresactuales ta) async {
  try {
    await db.collection('transformadores2025').doc(ta.id).set(ta.toJson());
    return 200;
  } catch (_) {
    return 500;
  }
}

Future<int> deleteTransformadorActual(String id) async {
  try {
    await db.collection('transformadores2025').doc(id).delete();
    return 200;
  } catch (_) {
    return 500;
  }
}

/// Stream
Stream<List<Tranformadoresactuales>> transformadoresActualesStream() {
  return db.collection("transformadores2025").snapshots().map((snapshot) =>
      snapshot.docs.map((doc) {
        try {
          final raw = doc.data();
          print('transformadoresActualesStream doc.id=${doc.id} data=$raw');
          final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
          var transformador = Tranformadoresactuales.fromMap(data);
          transformador.id = doc.id;
          return transformador;
        } catch (e) {
          print('transformadoresActualesStream parse error for doc ${doc.id}: $e');
          return Tranformadoresactuales(
            area: '',
            consecutivo: 0,
            fecha_de_llegada: DateTime(1900),
            mes: '',
            marca: '',
            aceite: '',
            economico: '',
            capacidadKVA: 0,
            fases: 0,
            serie: '',
            peso_placa_de_datos: '',
            fecha_fabricacion: DateTime(1900),
            fecha_prueba: DateTime(1900),
            valor_prueba_1: '',
            valor_prueba_2: '',
            valor_prueba_3: '',
            resistencia_aislamiento_megaoms: 0,
            rigidez_dielecrica_kv: '',
            estado: '',
            fecha_de_entrada_al_taller: DateTime(1900),
            fecha_de_salida_del_taller: DateTime(1900),
            fecha_entrega_almacen: DateTime(1900),
            salida_mantenimiento: false,
            fecha_salida_mantenimiento: null,
            baja: '',
            cargas: 0,
            area_fecha_de_entrega_transformador_reparado: '',
          );
        }
      }).toList());
}
