import 'package:cloud_firestore/cloud_firestore.dart';
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
  DateTime fechaMovimiento;
  bool reparado;
  String? motivo; // Nuevo campo opcional

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
  });
  factory TransformadoresXZona.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value is DateTime) return value;
      if (value is Timestamp) return value.toDate();
      if (value is String) return RangoFecha._parseFechaDMY(value);
      throw FormatException('Tipo de fecha no soportado: $value');
    }
    return TransformadoresXZona(
      zona: map['Zona']?.toString() ?? '',
      numEconomico: map['Numero_economico'] is int
          ? map['Numero_economico']
          : int.tryParse(map['Numero_economico']?.toString() ?? '0') ?? 0,
      marca: map['Marca']?.toString() ?? '',
      capacidad: map['Capacidad'] is double
          ? map['Capacidad']
          : double.tryParse(map['Capacidad']?.toString() ?? '0') ?? 0,
      fase: map['Fase'] is int
          ? map['Fase']
          : int.tryParse(map['Fase']?.toString() ?? '0') ?? 0,
      numeroDeSerie: map['Numero_de_serie']?.toString() ?? '',
      litros: map['Litros']?.toString() ?? '',
      pesoKg: map['Peso_kg']?.toString() ?? '',
      relacion: map['Relacion'] is int
          ? map['Relacion']
          : int.tryParse(map['Relacion']?.toString() ?? '0') ?? 0,
      status: map['Status']?.toString() ?? '',
      fechaMovimiento: parseDate(map['Fecha_mov']),
      reparado: map['Reparado'] is bool
          ? map['Reparado']
          : map['Reparado']?.toString().toLowerCase() == 'true',
      motivo: map['Motivo'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
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
  }
}