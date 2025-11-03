import 'motivo.dart';
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
  DateTime? fecha_salida_mantenimiento;
  String baja;
  int cargas;
  String area_fecha_de_entrega_transformador_reparado;
  String? motivo;
  List<Motivo>? motivos;
  // Nuevos campos para tracking de mantenimiento
  bool enviadoMantenimiento;
  DateTime? fechaEnvioMantenimiento;

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
    this.fecha_salida_mantenimiento,
    required this.baja,
    required this.cargas,
    required this.area_fecha_de_entrega_transformador_reparado,
    this.motivo,
    this.motivos,
    this.enviadoMantenimiento = false,
    this.fechaEnvioMantenimiento,
  });

  factory Tranformadoresactuales.fromMap(Map<String, dynamic> map) {
    dynamic get(Map<String, dynamic> m, List<String> keys) {
      for (var k in keys) {
        if (m.containsKey(k) && m[k] != null) return m[k];
      }
      return null;
    }

    try {
      return Tranformadoresactuales(
        id: map['id'] as String?,
        area: get(map, ['Area', 'area'])?.toString() ?? '',
        economico: get(map, ['Economico', 'economico', 'Economico'])?.toString() ?? '',
        capacidadKVA: (() {
          final v = get(map, ['CapacidadKVA', 'Capacidad KVA', 'capacidad']);
          if (v is double) return v;
          if (v is num) return v.toDouble();
          return double.tryParse(v?.toString() ?? '0') ?? 0;
        })(),
        consecutivo: (() {
          final v = get(map, ['Consecutivo', 'consecutivo']);
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '0') ?? 0;
        })(),
        fecha_de_llegada: _parseFecha(get(map, ['Fecha_de_llegada', 'fecha_de_llegada'])),
        fases: (() {
          final v = get(map, ['Fase', 'fases']);
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '0') ?? 0;
        })(),
        serie: get(map, ['Serie', 'serie'])?.toString() ?? '',
        mes: get(map, ['Mes', 'mes'])?.toString() ?? '',
        marca: get(map, ['Marca', 'marca'])?.toString() ?? '',
        aceite: get(map, ['Aceite', 'aceite'])?.toString() ?? '',
        peso_placa_de_datos: get(map, ['Peso_placa_de_datos', 'peso_placa_de_datos'])?.toString() ?? '',
        fecha_fabricacion: _parseFecha(get(map, ['Fecha_fabricacion', 'fecha_fabricacion'])),
        fecha_prueba: _parseFecha(get(map, ['Fecha_prueba', 'fecha_prueba'])),
        valor_prueba_1: get(map, ['Valor_prueba_1', 'valor_prueba_1'])?.toString() ?? '',
        valor_prueba_2: get(map, ['Valor_prueba_2', 'valor_prueba_2'])?.toString() ?? '',
        valor_prueba_3: get(map, ['Valor_prueba_3', 'valor_prueba_3'])?.toString() ?? '',
        resistencia_aislamiento_megaoms: (() {
          final v = get(map, ['Resistencia_aislamiento_megaoms', 'resistencia_aislamiento_megaoms']);
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '0') ?? 0;
        })(),
        rigidez_dielecrica_kv: get(map, ['Rigidez_dielecrica_kv', 'rigidez_dielecrica_kv'])?.toString() ?? '',
        estado: get(map, ['Estado', 'estado'])?.toString() ?? '',
        fecha_de_entrada_al_taller: _parseFecha(get(map, ['Fecha_de_entrada_al_taller', 'fecha_de_entrada_al_taller'])),
        fecha_de_salida_del_taller: _parseFecha(get(map, ['Fecha_de_salida_del_taller', 'fecha_de_salida_del_taller'])),
        fecha_entrega_almacen: _parseFecha(get(map, ['Fecha_entrega_almacen', 'fecha_entrega_almacen'])),
        salida_mantenimiento: (() {
          final v = get(map, ['Salida_mantenimiento', 'salida_mantenimiento']);
          if (v is bool) return v;
          return v?.toString() == 'true';
        })(),
        fecha_salida_mantenimiento: get(map, ['Fecha_salida_mantenimiento', 'fecha_salida_mantenimiento']) != null
            ? _parseFecha(get(map, ['Fecha_salida_mantenimiento', 'fecha_salida_mantenimiento']))
            : null,
        baja: get(map, ['Baja', 'baja'])?.toString() ?? '',
        cargas: (() {
          final v = get(map, ['Cargas', 'cargas']);
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '0') ?? 0;
        })(),
        area_fecha_de_entrega_transformador_reparado: get(map, ['Aerea_fecha_de_entrega_transformador_reparado', 'area_fecha_de_entrega_transformador_reparado'])?.toString() ?? '',
        motivo: get(map, ['Motivo', 'motivo']) as String?,
        motivos: (get(map, ['Motivos', 'motivos']) as List?)
            ?.map((m) => Motivo.fromMap(m as Map<String, dynamic>))
            .toList(),
        enviadoMantenimiento: (() {
          final v = get(map, ['enviadoMantenimiento']);
          if (v is bool) return v;
          return v?.toString() == 'true';
        })(),
        fechaEnvioMantenimiento: _parseFecha(get(map, ['fechaEnvioMantenimiento'])),
      );
    } catch (e) {
      print('Tranformadoresactuales.fromMap parse error: $e -- map: $map');
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
        enviadoMantenimiento: false,
        fechaEnvioMantenimiento: null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    final json = {
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
      'enviadoMantenimiento': enviadoMantenimiento,
      'fechaEnvioMantenimiento': fechaEnvioMantenimiento,
    };
    if (motivos != null) {
      json['Motivos'] = motivos!.map((m) => m.toJson()).toList();
    }
    return json;
  }
}