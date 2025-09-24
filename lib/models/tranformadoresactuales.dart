import 'package:cloud_firestore/cloud_firestore.dart';

DateTime _parseFecha(dynamic fecha) {
  if (fecha == null) return DateTime(1900, 1, 1);
  if (fecha is Timestamp) return fecha.toDate();
  if (fecha is String) {
    final partes = fecha.split('/');
    if (partes.length == 3) {
      final dia = int.tryParse(partes[0]) ?? 1;
      final mes = int.tryParse(partes[1]) ?? 1;
      final anio = int.tryParse(partes[2]) ?? 1900;
      return DateTime(anio, mes, dia);
    }
    return DateTime.tryParse(fecha) ?? DateTime(1900, 1, 1);
  }
  return DateTime(1900, 1, 1);
}

class Tranformadoresactuales {
  String? id;
  String area;
  int consecutivo;
  DateTime fecha_de_llegada;
  String mes;
  String marca;
  String aceite;
  String economico;
  double capacidadKVA;
  int fases;
  String serie;
  String peso_placa_de_datos;
  DateTime fecha_fabricacion;
  DateTime fecha_prueba;
  String valor_prueba_1;
  String valor_prueba_2;
  String valor_prueba_3;
  int resistencia_aislamiento_megaoms;
  String rigidez_dielecrica_kv;
  String estado;
  DateTime fecha_de_entrada_al_taller;
  DateTime fecha_de_salida_del_taller;
  DateTime fecha_entrega_almacen;
  bool salida_mantenimiento;
  DateTime? fecha_salida_mantenimiento; // <-- Permite nulo
  String baja;
  int cargas;
  String area_fecha_de_entrega_transformador_reparado;
  String? motivo; // Ya permite nulo

  Tranformadoresactuales({
    this.id,
    required this.area,
    required this.consecutivo,
    required this.fecha_de_llegada,
    required this.mes,
    required this.marca,
    required this.aceite,
    required this.economico,
    required this.capacidadKVA,
    required this.fases,
    required this.serie,
    required this.peso_placa_de_datos,
    required this.fecha_fabricacion,
    required this.fecha_prueba,
    required this.valor_prueba_1,
    required this.valor_prueba_2,
    required this.valor_prueba_3,
    required this.resistencia_aislamiento_megaoms,
    required this.rigidez_dielecrica_kv,
    required this.estado,
    required this.fecha_de_entrada_al_taller,
    required this.fecha_de_salida_del_taller,
    required this.fecha_entrega_almacen,
    required this.salida_mantenimiento,
    this.fecha_salida_mantenimiento, // <-- Permite nulo
    required this.baja,
    required this.cargas,
    required this.area_fecha_de_entrega_transformador_reparado,
    this.motivo,
  });

  factory Tranformadoresactuales.fromMap(Map<String, dynamic> map) {
    return Tranformadoresactuales(
      id: map['id'] as String?,
      area: map['Area']?.toString() ?? '',
      economico: map['Economico']?.toString() ?? '',
      capacidadKVA: map['CapacidadKVA'] is double
          ? map['CapacidadKVA']
          : double.tryParse(map['Capacidad KVA']?.toString() ?? '0') ?? 0,
      consecutivo: map['Consecutivo'] is int
          ? map['Consecutivo']
          : int.tryParse(map['Consecutivo']?.toString() ?? '0') ?? 0,
      fecha_de_llegada: _parseFecha(map['Fecha_de_llegada']),
      fases: map['Fase'] is int
          ? map['Fase']
          : int.tryParse(map['Fase']?.toString() ?? '0') ?? 0,
      serie: map['Serie']?.toString() ?? '',
      mes: map['Mes']?.toString() ?? '',
      marca: map['Marca']?.toString() ?? '',
      aceite: map['Aceite']?.toString() ?? '',
      peso_placa_de_datos: map['Peso_placa_de_datos']?.toString() ?? '',
      fecha_fabricacion: _parseFecha(map['Fecha_fabricacion']),
      fecha_prueba: _parseFecha(map['Fecha_prueba']),
      valor_prueba_1: map['Valor_prueba_1']?.toString() ?? '',
      valor_prueba_2: map['Valor_prueba_2']?.toString() ?? '',
      valor_prueba_3: map['Valor_prueba_3']?.toString() ?? '',
      resistencia_aislamiento_megaoms: map['Resistencia_aislamiento_megaoms'] is int
          ? map['Resistencia_aislamiento_megaoms']
          : int.tryParse(map['Resistencia_aislamiento_megaoms']?.toString() ?? '0') ?? 0,
      rigidez_dielecrica_kv: map['Rigidez_dielecrica_kv']?.toString() ?? '',
      estado: map['Estado']?.toString() ?? '',
      fecha_de_entrada_al_taller: _parseFecha(map['Fecha_de_entrada_al_taller']),
      fecha_de_salida_del_taller: _parseFecha(map['Fecha_de_salida_del_taller']),
      fecha_entrega_almacen: _parseFecha(map['Fecha_entrega_almacen']),
      salida_mantenimiento: map['Salida_mantenimiento'] == true || map['Salida_mantenimiento'] == 'true',
      fecha_salida_mantenimiento: map['Fecha_salida_mantenimiento'] != null
          ? _parseFecha(map['Fecha_salida_mantenimiento'])
          : null,
      baja: map['Baja']?.toString() ?? '',
      cargas: map['Cargas'] is int
          ? map['Cargas']
          : int.tryParse(map['Cargas']?.toString() ?? '0') ?? 0,
      area_fecha_de_entrega_transformador_reparado: map['Aerea_fecha_de_entrega_transformador_reparado']?.toString() ?? '',
      motivo: map['Motivo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Area': area,
      'Economico': economico,
      'CapacidadKVA': capacidadKVA,
      'Consecutivo': consecutivo,
      'Fecha_de_llegada': fecha_de_llegada,
      'Fase': fases,
      'Serie': serie,
      'Mes': mes,
      'Marca': marca,
      'Aceite': aceite,
      'Peso_placa_de_datos': peso_placa_de_datos,
      'Fecha_fabricacion': fecha_fabricacion,
      'Fecha_prueba': fecha_prueba,
      'Valor_prueba_1': valor_prueba_1,
      'Valor_prueba_2': valor_prueba_2,
      'Valor_prueba_3': valor_prueba_3,
      'Resistencia_aislamiento_megaoms': resistencia_aislamiento_megaoms,
      'Rigidez_dielecrica_kv': rigidez_dielecrica_kv,
      'Estado': estado,
      'Fecha_de_entrada_al_taller': fecha_de_entrada_al_taller,
      'Fecha_de_salida_del_taller': fecha_de_salida_del_taller,
      'Fecha_entrega_almacen': fecha_entrega_almacen,
      'Salida_mantenimiento': salida_mantenimiento,
      'Fecha_salida_mantenimiento': fecha_salida_mantenimiento,
      'Baja': baja,
      'Cargas': cargas,
      'Aerea_fecha_de_entrega_transformador_reparado': area_fecha_de_entrega_transformador_reparado,
      'Motivo': motivo,
    };
  }
}
