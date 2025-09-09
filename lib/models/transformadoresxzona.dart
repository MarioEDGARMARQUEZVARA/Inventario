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
      fechaMovimiento: DateTime.tryParse(map['Fecha_mov']?.toString() ?? '') ?? DateTime.now(),
      reparado: map['Reparado'] is bool
          ? map['Reparado']
          : map['Reparado']?.toString().toLowerCase() == 'true',
      motivo: map['Motivo'] as String?,
    );
  }
}