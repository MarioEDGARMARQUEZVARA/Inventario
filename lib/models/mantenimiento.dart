
class RangoFecha {
  final DateTime inicio;
  final DateTime fin;

  RangoFecha({required this.inicio, required this.fin});

  factory RangoFecha.fromString(String fechas) {
    final partes = fechas.split(',');
    return RangoFecha(
      inicio: _parseFechaDMY(partes[0].trim()),
      fin: _parseFechaDMY(partes[1].trim()),
    );
  }

  static DateTime _parseFechaDMY(String fecha) {
    final partes = fecha.split('/');
    if (partes.length != 3) throw FormatException('Formato de fecha inválido: $fecha');
    final dia = int.parse(partes[0]);
    final mes = int.parse(partes[1]);
    final anio = int.parse(partes[2]);
    return DateTime(anio, mes, dia);
  }
}

class Mantenimiento {
  String? id;
  String area;
  double capacidad;
  String economico;
  String estado;
  int fases;
  DateTime fecha_de_alta;
  DateTime fecha_de_salida;
  DateTime fecha_fabricacion;
  DateTime fecha_llegada;

  RangoFecha fecha_prueba;
  String kilos;
  String litros;
  String marca;
  int numero_mantenimiento;
  int resistencia_aislamiento;
  String rigidez_dieletrica;
  double? rt_fase_a;
  double? rt_fase_b;
  double? rt_fase_c;
  String serie;

  Mantenimiento({
    this.id = '',
    required this.area,
    required this.capacidad,
    required this.economico,
    required this.estado,
    required this.fases,
    required this.fecha_de_alta,
    required this.fecha_de_salida,
    required this.fecha_fabricacion,
    required this.fecha_llegada,
    required this.fecha_prueba,
    required this.kilos,
    required this.litros,
    required this.marca,
    required this.numero_mantenimiento,
    required this.resistencia_aislamiento,
    required this.rigidez_dieletrica,
    this.rt_fase_a,
    this.rt_fase_b,
    this.rt_fase_c,
    required this.serie,
  });

  factory Mantenimiento.fromMap(Map<String, dynamic> map) {
    return Mantenimiento(
      area: map['Area'] ?? '',
      capacidad: (map['Capacidad'] is num) ? map['Capacidad'].toDouble() : double.tryParse(map['Capacidad'].toString()) ?? 0.0,
      economico: map['Economico'] ?? '',
      estado: map['Estado'] ?? '',
      fases: map['Fases'] ?? 0,
      fecha_de_alta: RangoFecha._parseFechaDMY(map['Fecha_de_alta']),
      fecha_de_salida: RangoFecha._parseFechaDMY(map['Fecha_de_salida']),
      fecha_fabricacion: RangoFecha._parseFechaDMY(map['Fecha_fabricacion']),
      fecha_llegada: RangoFecha._parseFechaDMY(map['Fecha_llegada']),
      fecha_prueba: RangoFecha.fromString(map['Fecha_prueba'] ?? ''),
      kilos: map['Kilos'] ?? '',
      litros: map['Litros'] ?? '',
      marca: map['Marca'] ?? '',
      numero_mantenimiento: map['Numero_mantenimiento'] ?? 0,
      resistencia_aislamiento: map['Resistencia_aislamiento'] ?? 0,
      rigidez_dieletrica: map['Rigidez_dieletrica'] ?? '',
  rt_fase_a: (map['Rt_fase_a'] is num) ? map['Rt_fase_a'].toDouble() : double.tryParse(map['Rt_fase_a']?.toString() ?? ''),
  rt_fase_b: (map['Rt_fase_b'] is num) ? map['Rt_fase_b'].toDouble() : double.tryParse(map['Rt_fase_b']?.toString() ?? ''),
  rt_fase_c: (map['Rt_fase_c'] is num) ? map['Rt_fase_c'].toDouble() : double.tryParse(map['Rt_fase_c']?.toString() ?? ''),
      serie: map['Serie'] ?? '',
    );
  }
}