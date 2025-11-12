import 'package:cloud_firestore/cloud_firestore.dart';
import 'motivo.dart';

class RangoFecha {
  final DateTime inicio;
  final DateTime fin;

  RangoFecha({required this.inicio, required this.fin});

  factory RangoFecha.fromFirestore(dynamic fechas) {
    if (fechas is String) {
      final partes = fechas.split(',');
      return RangoFecha(
        inicio: _parseFechaDMY(partes[0].trim()),
        fin: _parseFechaDMY(partes[1].trim()),
      );
    } else if (fechas is Map<String, dynamic>) {
      return RangoFecha(
        inicio: _parseFirestoreDate(fechas['inicio']),
        fin: _parseFirestoreDate(fechas['fin']),
      );
    }
    throw FormatException('Formato de fecha inválido: $fechas');
  }

  static DateTime _parseFechaDMY(String fecha) {
    final partes = fecha.split('/');
    if (partes.length != 3) throw FormatException('Formato de fecha inválido: $fecha');
    final dia = int.parse(partes[0]);
    final mes = int.parse(partes[1]);
    final anio = int.parse(partes[2]);
    return DateTime(anio, mes, dia);
  }

  static DateTime _parseFirestoreDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is String) return _parseFechaDMY(value);
    throw FormatException('Tipo de fecha no soportado: $value');
  }
}

class TransformadoresXZona {
  String? id;
  String zona;
  int economico;
  String marca;
  double capacidadKVA;
  int fases;
  String serie;
  String aceite;
  String peso_placa_de_datos;
  int relacion;
  String estado;
  DateTime? fechaMovimiento;
  bool reparado;
  String? motivo;
  List<Motivo>? motivos;
  bool enviadoMantenimiento;
  DateTime? fechaEnvioMantenimiento;
  int contadorEnviosMantenimiento;

  TransformadoresXZona({
    this.id,
    required this.zona,
    required this.economico,
    required this.marca,
    required this.capacidadKVA,
    required this.fases,
    required this.serie,
    required this.aceite,
    required this.peso_placa_de_datos,
    required this.relacion,
    required this.estado, 
    required this.fechaMovimiento,
    required this.reparado,
    this.motivo,
    this.motivos,
    this.enviadoMantenimiento = false,
    this.fechaEnvioMantenimiento,
    this.contadorEnviosMantenimiento = 0, 
  });

  factory TransformadoresXZona.fromMap(Map<String, dynamic> map) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is Timestamp) return value.toDate();
      if (value is String) {
        try {
          return RangoFecha._parseFechaDMY(value);
        } catch (_) {
          return DateTime.tryParse(value);
        }
      }
      return null;
    }

    dynamic get(Map<String, dynamic> m, List<String> keys) {
      for (var k in keys) {
        if (m.containsKey(k) && m[k] != null) return m[k];
      }
      return null;
    }

    return TransformadoresXZona(
      zona: get(map, ['Zona', 'zona', 'ZONA'])?.toString() ?? '',
      economico: (() {
        final v = get(map, ['Economico', 'economico']);
        if (v is int) return v;
        return int.tryParse(v?.toString() ?? '0') ?? 0;
      })(),
      marca: get(map, ['Marca', 'marca'])?.toString() ?? '',
      capacidadKVA: (() {
        final v = get(map, ['CapacidadKVA', 'capacidadKVA']);
        if (v is double) return v;
        if (v is num) return v.toDouble();
        return double.tryParse(v?.toString() ?? '0') ?? 0;
      })(),
      fases: (() {
        final v = get(map, ['fases', 'fases']);
        if (v is int) return v;
        return int.tryParse(v?.toString() ?? '0') ?? 0;
      })(),
      serie: get(map, ['Numero_de_serie', 'serie', 'serie'])?.toString() ?? '',
      aceite: get(map, ['aceite', 'aceite'])?.toString() ?? '',
      peso_placa_de_datos: get(map, ['Peso_kg', 'peso_placa_de_datos', 'peso_kg'])?.toString() ?? '',
      relacion: (() {
        final v = get(map, ['Relacion', 'relacion']);
        if (v is int) return v;
        return int.tryParse(v?.toString() ?? '0') ?? 0;
      })(),
      estado: get(map, ['Estado', 'estado'])?.toString() ?? '', // CAMBIADO: Status -> Estado
      fechaMovimiento: parseDate(get(map, ['Fecha_mov', 'FechaMovimiento', 'fechaMovimiento'])),
      reparado: (() {
        final v = get(map, ['Reparado', 'reparado']);
        if (v is bool) return v;
        return v?.toString().toLowerCase() == 'true';
      })(),
      motivo: get(map, ['Motivo', 'motivo']) as String?,
      motivos: (get(map, ['Motivos', 'motivos']) as List?)
          ?.map((m) => Motivo.fromMap(m as Map<String, dynamic>))
          .toList(),
      enviadoMantenimiento: (() {
        final v = get(map, ['enviadoMantenimiento']);
        if (v is bool) return v;
        return v?.toString() == 'true';
      })(),
      fechaEnvioMantenimiento: parseDate(get(map, ['fechaEnvioMantenimiento'])),
      contadorEnviosMantenimiento: (() {
        final v = get(map, ['contadorEnviosMantenimiento']);
        if (v is int) return v;
        return int.tryParse(v?.toString() ?? '0') ?? 0;
      })(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'Zona': zona,
      'Economico': economico,
      'Marca': marca,
      'CapacidadKVA': capacidadKVA,
      'fases': fases,
      'Numero_de_serie': serie,
      'aceite': aceite,
      'Peso_kg': peso_placa_de_datos,
      'Relacion': relacion,
      'Estado': estado, 
      'Fecha_mov': fechaMovimiento,
      'Reparado': reparado,
      'Motivo': motivo,
      'enviadoMantenimiento': enviadoMantenimiento,
      'fechaEnvioMantenimiento': fechaEnvioMantenimiento,
      'contadorEnviosMantenimiento': contadorEnviosMantenimiento,
    };
    if (motivos != null) {
      json['Motivos'] = motivos!.map((m) => m.toJson()).toList();
    }
    return json;
  }
}