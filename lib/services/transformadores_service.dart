import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';

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

  Future<void> agregarMotivoTransformadorActual(String id, String motivo) async {
    await FirebaseFirestore.instance
        .collection('transformadores2025')
        .doc(id)
        .collection('Motivos')
        .add({'Motivo': motivo, 'fecha': DateTime.now()});
  }

  Future<void> agregarTransformadorActual(Tranformadoresactuales transformador) async {
    await _transformadoresRef.add({
      'Area': transformador.area,
      'Consecutivo': transformador.consecutivo,
      'Fecha_de_llegada': '${transformador.fecha_de_llegada.day}/${transformador.fecha_de_llegada.month}/${transformador.fecha_de_llegada.year}',
      'Mes': transformador.mes,
      'Marca': transformador.marca,
      'Aceite': transformador.aceite,
      'Economico': transformador.economico,
      'CapacidadKVA': transformador.capacidadKVA,
      'Fase': transformador.fases,
      'Serie': transformador.serie,
      'Peso_placa_de_datos': transformador.peso_placa_de_datos,
      'Fecha_fabricacion': '${transformador.fecha_fabricacion.day}/${transformador.fecha_fabricacion.month}/${transformador.fecha_fabricacion.year}',
      'Fecha_prueba': '${transformador.fecha_prueba.day}/${transformador.fecha_prueba.month}/${transformador.fecha_prueba.year}',
      'Valor_prueba_1': transformador.valor_prueba_1,
      'Valor_prueba_2': transformador.valor_prueba_2,
      'Valor_prueba_3': transformador.valor_prueba_3,
      'Resistencia_aislamiento_megaoms': transformador.resistencia_aislamiento_megaoms,
      'Rigidez_dielecrica_kv': transformador.rigidez_dielecrica_kv,
      'Estado': transformador.estado,
      'Fecha_de_entrada_al_taller': '${transformador.fecha_de_entrada_al_taller.day}/${transformador.fecha_de_entrada_al_taller.month}/${transformador.fecha_de_entrada_al_taller.year}',
      'Fecha_de_salida_del_taller': '${transformador.fecha_de_salida_del_taller.day}/${transformador.fecha_de_salida_del_taller.month}/${transformador.fecha_de_salida_del_taller.year}',
      'Fecha_entrega_almacen': '${transformador.fecha_entrega_almacen.day}/${transformador.fecha_entrega_almacen.month}/${transformador.fecha_entrega_almacen.year}',
      'Salida_mantenimiento': transformador.salida_mantenimiento,
      'Fecha_salida_mantenimiento': '${transformador.fecha_salida_mantenimiento.day}/${transformador.fecha_salida_mantenimiento.month}/${transformador.fecha_salida_mantenimiento.year}',
      'Baja': transformador.baja,
      'Cargas': transformador.cargas,
      'Aerea_fecha_de_entrega_transformador_reparado': transformador.area_fecha_de_entrega_transformador_reparado,
      // No se agrega 'Motivo' aquí
    });
  }
}
