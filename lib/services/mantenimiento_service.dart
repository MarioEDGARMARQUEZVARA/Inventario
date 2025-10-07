import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:inventario_proyecto/models/motivo.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// Obtener lista de mantenimiento
Future<List<Mantenimiento>> getMantenimientos() async {
  QuerySnapshot query = await db.collection("mantenimiento2025").get();
  return query.docs.map((doc) {
    try {
      final raw = doc.data();
      print('getMantenimientos doc.id=${doc.id} data=$raw');
      final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
      var mantenimiento = Mantenimiento.fromMap(data);
      mantenimiento.id = doc.id;
      return mantenimiento;
    } catch (e) {
      print('getMantenimientos parse error for doc ${doc.id}: $e');
      return Mantenimiento(
        area: '',
        capacidad: 0.0,
        economico: '',
        estado: '',
        fases: 0,
        fecha_de_alta: null,
        fecha_de_salida: null,
        fecha_fabricacion: null,
        fecha_llegada: null,
        fecha_prueba: RangoFecha(inicio: null, fin: null),
        kilos: '',
        litros: '',
        marca: '',
        numero_mantenimiento: 0,
        resistencia_aislamiento: 0,
        rigidez_dieletrica: '',
        serie: '',
      );
    }
  }).toList();
}

/// Marcar como reparado y devolver al origen
Future<int> marcarReparado(String id, {String? destinoManual}) async {
  int code = 0;
  try {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await db.collection("mantenimiento2025").doc(id).get();

    if (doc.exists) {
      Map<String, dynamic>? data = doc.data();
      String? origen = data?["origen"];

      // Decidir destino
      String destino;
      if (origen == "transformadores2025" || origen == "Transformadoresxzona") {
        destino = origen!;
      } else if (destinoManual != null) {
        destino = destinoManual; // Elegido manualmente
      } else {
        return 400; // Falta decidir destino
      }

      // Copiar a destino
      await db.collection(destino).add(data!);

      // Eliminar de mantenimiento
      await db.collection("mantenimiento2025").doc(id).delete();

      code = 200;
    } else {
      code = 404;
    }
  } catch (_) {
    code = 500;
  }
  return code;
}

/// CRUD
Future<int> addMantenimiento(Mantenimiento m) async {
  try {
    await db.collection("mantenimiento2025").add(m.toJson());
    return 200;
  } catch (e) {
    return 500;
  }
}

Future<int> updateMantenimiento(Mantenimiento m) async {
  try {
    await db.collection("mantenimiento2025").doc(m.id).set(m.toJson());
    return 200;
  } catch (e) {
    return 500;
  }
}

Future<int> deleteMantenimiento(String id) async {
  try {
    await db.collection("mantenimiento2025").doc(id).delete();
    return 200;
  } catch (e) {
    return 500;
  }
}

/// Stream
Stream<List<Mantenimiento>> mantenimientosStream() {
  return db.collection("mantenimiento2025").snapshots().map((snapshot) =>
      snapshot.docs.map((doc) {
        try {
          final raw = doc.data();
          print('mantenimientosStream doc.id=${doc.id} data=$raw');
          final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
          var mantenimiento = Mantenimiento.fromMap(data);
          mantenimiento.id = doc.id;
          return mantenimiento;
        } catch (e) {
          print('mantenimientosStream parse error for doc ${doc.id}: $e');
          return Mantenimiento(
            area: '',
            capacidad: 0.0,
            economico: '',
            estado: '',
            fases: 0,
            fecha_de_alta: null,
            fecha_de_salida: null,
            fecha_fabricacion: null,
            fecha_llegada: null,
            fecha_prueba: RangoFecha(inicio: null, fin: null),
            kilos: '',
            litros: '',
            marca: '',
            numero_mantenimiento: 0,
            resistencia_aislamiento: 0,
            rigidez_dieletrica: '',
            serie: '',
          );
        }
      }).toList());
}
