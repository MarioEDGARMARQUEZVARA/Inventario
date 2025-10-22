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
  int numEconomico;
  String marca;
  double capacidad;
  int fase;
  String numeroDeSerie;
  String litros;
  String pesoKg;
  int relacion;
  String status;
  DateTime? fechaMovimiento;
  bool reparado;
  String? motivo;
  List<Motivo>? motivos; 

  TransformadoresXZona({
    this.id,
    required this.zona,
    required this.numEconomico,
    required this.marca,
    required this.capacidad,
    required this.fase,
    required this.numeroDeSerie,
    required this.litros,
    required this.pesoKg,
    required this.relacion,
    required this.status,
    required this.fechaMovimiento,
    required this.reparado,
    this.motivo,
    this.motivos,
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
    // Helper to try multiple possible keys that may exist in Firestore docs
    dynamic get(Map<String, dynamic> m, List<String> keys) {
      for (var k in keys) {
        if (m.containsKey(k) && m[k] != null) return m[k];
      }
      return null;
    }
    return TransformadoresXZona(
      zona: get(map, ['Zona', 'zona', 'ZONA'])?.toString() ?? '',
      numEconomico: (() {
        final v = get(map, ['Numero_economico', 'NumeroEconomico', 'numero_economico', 'economico']);
        if (v is int) return v;
        return int.tryParse(v?.toString() ?? '0') ?? 0;
      })(),
      marca: get(map, ['Marca', 'marca'])?.toString() ?? '',
      capacidad: (() {
        final v = get(map, ['Capacidad', 'CapacidadKVA', 'capacidad']);
        if (v is double) return v;
        if (v is num) return v.toDouble();
        return double.tryParse(v?.toString() ?? '0') ?? 0;
      })(),
      fase: (() {
        final v = get(map, ['Fase', 'fase']);
        if (v is int) return v;
        return int.tryParse(v?.toString() ?? '0') ?? 0;
      })(),
      numeroDeSerie: get(map, ['Numero_de_serie', 'NumeroDeSerie', 'serie'])?.toString() ?? '',
      litros: get(map, ['Litros', 'litros'])?.toString() ?? '',
      pesoKg: get(map, ['Peso_kg', 'PesoKg', 'peso_kg'])?.toString() ?? '',
      relacion: (() {
        final v = get(map, ['Relacion', 'relacion']);
        if (v is int) return v;
        return int.tryParse(v?.toString() ?? '0') ?? 0;
      })(),
      status: get(map, ['Status', 'status'])?.toString() ?? '',
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

    );
  }
  Map<String, dynamic> toJson() {
    final json = {
      'Zona': zona,
      'Numero_economico': numEconomico,
      'Marca': marca,
      'Capacidad': capacidad,
      'Fase': fase,
      'Numero_de_serie': numeroDeSerie,
      'Litros': litros,
      'Peso_kg': pesoKg,
      'Relacion': relacion,
      'Status': status,
      'Fecha_mov': fechaMovimiento,
      'Reparado': reparado,
      'Motivo': motivo,
    };
    if (motivos != null) {
      json['Motivos'] = motivos!.map((m) => m.toJson()).toList();
    }
    return json;
  }
}