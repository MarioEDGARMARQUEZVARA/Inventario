import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';

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

  Future<void> addMantenimiento(Mantenimiento mantenimiento) async {
    await _mantenimientoRef.add({
      'Area': mantenimiento.area,
      'Capacidad': mantenimiento.capacidad,
      'Economico': mantenimiento.economico,
      'Estado': mantenimiento.estado,
      'Fases': mantenimiento.fases,
      'Fecha_de_alta': '${mantenimiento.fecha_de_alta.day}/${mantenimiento.fecha_de_alta.month}/${mantenimiento.fecha_de_alta.year}',
      'Fecha_de_salida': '${mantenimiento.fecha_de_salida.day}/${mantenimiento.fecha_de_salida.month}/${mantenimiento.fecha_de_salida.year}',
      'Fecha_fabricacion': '${mantenimiento.fecha_fabricacion.day}/${mantenimiento.fecha_fabricacion.month}/${mantenimiento.fecha_fabricacion.year}',
      'Fecha_llegada': '${mantenimiento.fecha_llegada.day}/${mantenimiento.fecha_llegada.month}/${mantenimiento.fecha_llegada.year}',
      'Fecha_prueba': '${mantenimiento.fecha_prueba.inicio.day}/${mantenimiento.fecha_prueba.inicio.month}/${mantenimiento.fecha_prueba.inicio.year},${mantenimiento.fecha_prueba.fin.day}/${mantenimiento.fecha_prueba.fin.month}/${mantenimiento.fecha_prueba.fin.year}',
      'Kilos': mantenimiento.kilos,
      'Litros': mantenimiento.litros,
      'Marca': mantenimiento.marca,
      'Numero_mantenimiento': mantenimiento.numero_mantenimiento,
      'Resistencia_aislamiento': mantenimiento.resistencia_aislamiento,
      'Rigidez_dieletrica': mantenimiento.rigidez_dieletrica,
      'Rt_fase_a': mantenimiento.rt_fase_a,
      'Rt_fase_b': mantenimiento.rt_fase_b,
      'Rt_fase_c': mantenimiento.rt_fase_c,
      'Serie': mantenimiento.serie,
      // No se agrega 'Motivo', ya que está en subcolección
    });
  }

}
