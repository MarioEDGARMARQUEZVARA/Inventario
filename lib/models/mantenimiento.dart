import 'motivo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RangoFecha {
  final DateTime? inicio;
  final DateTime? fin;

  RangoFecha({required this.inicio, required this.fin});

  factory RangoFecha.fromFirestore(dynamic fechas) {
    if (fechas == null) {
      return RangoFecha(inicio: null, fin: null);
    }
    if (fechas is String) {
      final partes = fechas.split(',');
      return RangoFecha(
        inicio: partes.isNotEmpty ? _parseFechaDMY(partes[0].trim()) : null,
        fin: partes.length > 1 ? _parseFechaDMY(partes[1].trim()) : null,
      );
    }
   
    if (fechas is Map<String, dynamic>) {
      return RangoFecha(
        inicio: _parseFirestoreDate(fechas['inicio']),
        fin: _parseFirestoreDate(fechas['fin']),
      );
    }
   
    if (fechas is Timestamp) {
      return RangoFecha(
        inicio: fechas.toDate(),
        fin: null,
      );
    }
    throw FormatException('Formato de fecha inválido: $fechas');
  }

  static DateTime? _parseFechaDMY(String fecha) {
    if (fecha.isEmpty) return null;
    final partes = fecha.split('/');
    if (partes.length != 3) return null;
    final dia = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    final anio = int.tryParse(partes[2]);
    if (dia == null || mes == null || anio == null) return null;
    return DateTime(anio, mes, dia);
  }

  static DateTime? _parseFirestoreDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is String) return _parseFechaDMY(value);
    return null;
  }
}

class Mantenimiento {
  String? id;
  String area;
  double? capacidadKVA;
  String economico;
  String estado;
  String? mes;
  int? consecutivo;
  DateTime? fecha_de_llegada;
  int fases;
  DateTime? fecha_entrega_almacen;
  String? valor_prueba_1;
  String? valor_prueba_2;
  String? valor_prueba_3;
  DateTime? fecha_de_alta;
  DateTime? fecha_de_salida_del_taller; // antes: fecha_de_salida
  DateTime? fecha_fabricacion;
  DateTime? fecha_de_entrada_al_taller; // antes: fecha_llegada
  DateTime? fecha_prueba_1;
  DateTime? fecha_prueba_2;
  DateTime? fecha_prueba;
  String peso_placa_de_datos;
  bool? salida_mantenimiento;
  DateTime? fecha_salida_mantenimiento;
  String aceite; 
  String marca;
  bool? baja;
  int numero_mantenimiento;
  int resistencia_aislamiento_megaoms; // antes: resistencia_aislamiento
  String rigidez_dielecrica_kv;
  double? rt_fase_a;
  double? rt_fase_b;
  double? rt_fase_c;
  String serie;
  bool enviadoMantenimiento;
  DateTime? fechaEnvioMantenimiento;
  String? motivo;
  List<Motivo>? motivos;
  int contador;
  String? zona;
  int? numEconomico;
  int? relacion;
  String? status;
  DateTime? fechaMovimiento;
  bool? reparado;
  int? cargas;
  String? area_fecha_de_entrega_transformador_reparado;
  DateTime? fechaReparacion;
  String? destinoReparado;

  Mantenimiento({
    this.id = '',
    required this.area,
    this.capacidadKVA,
    required this.economico,
    required this.estado,
    required this.fases,
    this.fecha_de_llegada,
    this.fecha_entrega_almacen,
    this.fecha_salida_mantenimiento,
    this.salida_mantenimiento,
    this.mes,
    this.consecutivo,
    this.enviadoMantenimiento = false,
    this.fechaEnvioMantenimiento,
    this.fecha_prueba_1,
    this.fecha_prueba_2,
    this.valor_prueba_1,
    this.valor_prueba_2,
    this.valor_prueba_3,
    required this.fecha_de_alta,
    required this.fecha_de_salida_del_taller,
    required this.fecha_fabricacion,
    required this.fecha_de_entrada_al_taller,
    this.fecha_prueba,
    required this.peso_placa_de_datos,
    required this.aceite,
    required this.marca,
    required this.numero_mantenimiento,
    required this.resistencia_aislamiento_megaoms,
    required this.rigidez_dielecrica_kv,
    this.rt_fase_a,
    this.rt_fase_b,
    this.rt_fase_c,
    required this.serie,
    this.motivo,
    this.motivos,
    this.contador = 0,
    this.zona,
    this.numEconomico,
    this.relacion,
    this.status,
    this.fechaMovimiento,
    this.reparado,
    this.baja,
    this.cargas,
    this.area_fecha_de_entrega_transformador_reparado,
    this.fechaReparacion,
    this.destinoReparado,
  });

  factory Mantenimiento.fromMap(Map<String, dynamic> map) {
    dynamic _parseFecha(dynamic value) {
      if (value == null) return null;
      try {
        if (value is DateTime) return value;
        if (value is Timestamp) return value.toDate();
        if (value is String) return DateTime.tryParse(value) ?? RangoFecha._parseFechaDMY(value);
      } catch (_) {
        return null;
      }
      return null;
    }

    String _parseString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is Timestamp) return value.toDate().toString();
      if (value is num) return value.toString();
      return value.toString();
    }

    dynamic get(Map<String, dynamic> m, List<String> keys) {
      for (var k in keys) {
        if (m.containsKey(k) && m[k] != null) return m[k];
      }
      return null;
    }

    try {
      return Mantenimiento(
        area: _parseString(get(map, ['Area', 'area'])),
        capacidadKVA: (() {
          final v = get(map, ['CapacidadKVA', 'capacidad_kva']);
          if (v is num) return v.toDouble();
          return double.tryParse(v?.toString() ?? '') ?? 0.0;
        })(),
        economico: _parseString(get(map, ['Economico', 'economico'])),
        estado: _parseString(get(map, ['Estado', 'estado'])),
        fases: (() {
          final v = get(map, ['Fases', 'fases', 'Fase']);
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '0') ?? 0;
        })(),
        mes: _parseString(get(map, ['Mes', 'mes'])),
            enviadoMantenimiento: (() {
        final v = get(map, ['enviadoMantenimiento']);
        if (v is bool) return v;
        return v?.toString() == 'true';
      })(),
      fechaEnvioMantenimiento: _parseFecha(get(map, ['fechaEnvioMantenimiento'])),
        fecha_de_llegada: _parseFecha(get(map, ['Fecha_de_llegada', 'fecha_de_llegada'])) ?? DateTime(1900),  
        consecutivo: (() {
          final v = get(map, ['Consecutivo', 'consecutivo']);
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '0');
        })(),
        fecha_prueba_1: _parseFecha(get(map, ['Fecha_prueba_1', 'fecha_prueba_1'])) ?? DateTime(1900),
        fecha_prueba_2: _parseFecha(get(map, ['Fecha_prueba_2', 'fecha_prueba_2'])) ?? DateTime(1900),
        valor_prueba_1: _parseString(get(map, ['Valor_prueba_1', 'valor_prueba_1'])),
        valor_prueba_2: _parseString(get(map, ['Valor_prueba_2', 'valor_prueba_2'])),
        valor_prueba_3: _parseString(get(map, ['Valor_prueba_3', 'valor_prueba_3'])),
        fecha_de_alta: _parseFecha(get(map, ['Fecha_de_alta', 'fecha_de_alta'])),
        fecha_de_salida_del_taller: _parseFecha(get(map, ['Fecha_de_salida_del_taller', 'fecha_de_salida', 'fecha_de_salida_del_taller'])),
        fecha_fabricacion: _parseFecha(get(map, ['Fecha_fabricacion', 'fecha_fabricacion'])),
        fecha_de_entrada_al_taller: _parseFecha(get(map, ['Fecha_de_entrada_al_taller', 'fecha_llegada', 'fecha_de_entrada_al_taller'])),
        fecha_prueba: _parseFecha(get(map, ['Fecha_prueba', 'fecha_prueba'])),
        peso_placa_de_datos: _parseString(get(map, ['Peso_placa_de_datos', 'peso_placa_de_datos'])),
        salida_mantenimiento: (() {
          final v = get(map, ['Salida_mantenimiento', 'salida_mantenimiento']);
          if (v is bool) return v;
          return v?.toString().toLowerCase() == 'true';
        })(),
        fecha_salida_mantenimiento: _parseFecha(get(map, ['Fecha_salida_mantenimiento', 'fecha_salida_mantenimiento'])),
        aceite: _parseString(get(map, ['Aceite', 'aceite', 'Litros', 'litros'])),
        marca: _parseString(get(map, ['Marca', 'marca'])),
        numero_mantenimiento: (() {
          final v = get(map, ['Numero_mantenimiento', 'numero_mantenimiento']);
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '0') ?? 0;
        })(),
        resistencia_aislamiento_megaoms: (() {
          final v = get(map, ['Resistencia_aislamiento_megaoms', 'resistencia_aislamiento_megaoms', 'Resistencia_aislamiento', 'resistencia_aislamiento']);
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '0') ?? 0;
        })(),
        rigidez_dielecrica_kv: _parseString(get(map, ['Rigidez_dielecrica_kv', 'rigidez_dielecrica_kv'])),
        rt_fase_a: (get(map, ['Rt_fase_a', 'rt_fase_a']) is num) ? (get(map, ['Rt_fase_a', 'rt_fase_a']) as num).toDouble() : double.tryParse(get(map, ['Rt_fase_a', 'rt_fase_a'])?.toString() ?? ''),
        rt_fase_b: (get(map, ['Rt_fase_b', 'rt_fase_b']) is num) ? (get(map, ['Rt_fase_b', 'rt_fase_b']) as num).toDouble() : double.tryParse(get(map, ['Rt_fase_b', 'rt_fase_b'])?.toString() ?? ''),
        rt_fase_c: (get(map, ['Rt_fase_c', 'rt_fase_c']) is num) ? (get(map, ['Rt_fase_c', 'rt_fase_c']) as num).toDouble() : double.tryParse(get(map, ['Rt_fase_c', 'rt_fase_c'])?.toString() ?? ''),
        serie: _parseString(get(map, ['Serie', 'serie','Numero_de_serie'])),
        motivo: _parseString(get(map, ['Motivo', 'motivo'])),
        motivos: (get(map, ['Motivos', 'motivos']) as List?)
            ?.map((m) => Motivo.fromMap(m as Map<String, dynamic>))
            .toList(),
        contador: (() {
          final v = get(map, ['contador']);
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '0') ?? 0;
        })(),
        fecha_entrega_almacen: _parseFecha(get(map, ['Fecha_entrega_almacen', 'fecha_entrega_almacen'])),
        zona: _parseString(get(map, ['Zona', 'zona'])),
        numEconomico: (() {
          final v = get(map, ['Numero_economico', 'NumeroEconomico', 'numero_economico']);
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '0');
        })(),
        relacion: (() {
          final v = get(map, ['Relacion', 'relacion']);
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '0');
        })(),
        status: _parseString(get(map, ['Status', 'status'])),
        fechaMovimiento: _parseFecha(get(map, ['Fecha_mov', 'fecha_mov'])),
        reparado: get(map, ['Reparado', 'reparado']),
        baja: (() {
          final v = get(map, ['Baja', 'baja']);
          if (v is bool) return v;
          return v?.toString().toLowerCase() == 'true';
        })(),
        cargas: (() {
          final v = get(map, ['Cargas', 'cargas']);
          if (v is int) return v;
          return int.tryParse(v?.toString() ?? '0');
        })(),
        area_fecha_de_entrega_transformador_reparado: _parseString(get(map, ['Aerea_fecha_de_entrega_transformador_reparado', 'area_fecha_de_entrega_transformador_reparado'])),
        fechaReparacion: _parseFecha(get(map, ['fechaReparacion'])),
        destinoReparado: _parseString(get(map, ['destinoReparado'])),
      );
    } catch (e) {
      print('Mantenimiento.fromMap parse error: $e -- map: $map');
      return Mantenimiento(
        area: '',
        capacidadKVA: 0.0,
        economico: '',
        estado: '',
        fases: 0,
        valor_prueba_1: '',
        valor_prueba_2: '',
        valor_prueba_3: '',
        fecha_de_alta: null,
        fecha_de_salida_del_taller: null,
        fecha_fabricacion: null,
        fecha_de_entrada_al_taller: null,
        fecha_prueba: null,
        fecha_prueba_1: DateTime(1900), // Default value for required parameter
        fecha_prueba_2: DateTime(1900), // Default value for required parameter
        peso_placa_de_datos: '',
        aceite: '',
        marca: '',
        numero_mantenimiento: 0,
        resistencia_aislamiento_megaoms: 0,
        rigidez_dielecrica_kv: '',
        serie: '',
      );
    }
  }

  Map<String, dynamic> toJson(){
    final json = {
      'Area': area,
      'CapacidadKVA': capacidadKVA,
      'Economico': economico,
      'Estado': estado,
      'Fases': fases,
      'Mes': mes,
      'Consecutivo': consecutivo,
      'Fecha_de_llegada': fecha_de_llegada,
      'Fecha_entrega_almacen': fecha_entrega_almacen,
      'Fecha_salida_mantenimiento': fecha_salida_mantenimiento,
      'Salida_mantenimiento': salida_mantenimiento,
      'Fecha_de_alta': fecha_de_alta,
      'Fecha_de_salida_del_taller': fecha_de_salida_del_taller,
      'Fecha_fabricacion': fecha_fabricacion,
      'Fecha_de_entrada_al_taller': fecha_de_entrada_al_taller,
      'Fecha_prueba': fecha_prueba,
      'Fecha_prueba_1': fecha_prueba_1,
      'Fecha_prueba_2': fecha_prueba_2,
      'Valor_prueba_1': valor_prueba_1,
      'Valor_prueba_2': valor_prueba_2,
      'Valor_prueba_3': valor_prueba_3,
      'Peso_placa_de_datos': peso_placa_de_datos,
      'Aceite': aceite,
      'Marca': marca,
      'Numero_mantenimiento': numero_mantenimiento,
      'Resistencia_aislamiento_megaoms': resistencia_aislamiento_megaoms,
      'Rigidez_dielecrica_kv': rigidez_dielecrica_kv,
      'Rt_fase_a': rt_fase_a,
      'Rt_fase_b': rt_fase_b,
      'Rt_fase_c': rt_fase_c,
      'Serie': serie,
      'Motivo': motivo,
      'contador': contador,
      'Zona': zona,
      'Numero_economico': numEconomico,
      'Relacion': relacion,
      'Status': status,
      'Fecha_mov': fechaMovimiento?.toIso8601String(),
      'Reparado': reparado,
      'Baja': baja,
      'Cargas': cargas,
      'Aerea_fecha_de_entrega_transformador_reparado': area_fecha_de_entrega_transformador_reparado,
      'fechaReparacion': fechaReparacion,
      'destinoReparado': destinoReparado,
      'enviadoMantenimiento': enviadoMantenimiento,
    'fechaEnvioMantenimiento': fechaEnvioMantenimiento,
    };
    if (motivos != null) {
      json['Motivos'] = motivos!.map((m) => m.toJson()).toList();
    }
    return json;
  }
}