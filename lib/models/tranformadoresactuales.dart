DateTime _parseFechaDMY(String? fecha) {
  if (fecha == null || fecha.isEmpty) return DateTime(1900, 1, 1);
  final partes = fecha.split('/');
  if (partes.length != 3) throw FormatException('Formato de fecha inválido: $fecha');
  final dia = int.tryParse(partes[0]) ?? 1;
  final mes = int.tryParse(partes[1]) ?? 1;
  final anio = int.tryParse(partes[2]) ?? 1900;
  return DateTime(anio, mes, dia);
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
  String salida_mantenimiento;
  DateTime fecha_salida_mantenimiento;
  String baja;
  int cargas;
  String area_fecha_de_entrega_transformador_reparado;

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
    required this.fecha_salida_mantenimiento,
    required this.baja,
    required this.cargas,
    required this.area_fecha_de_entrega_transformador_reparado,
  });

  factory Tranformadoresactuales.fromMap(Map<String, dynamic> map) {
    return Tranformadoresactuales(
      area: map['Area']?.toString() ?? '',
      economico: map['Economico']?.toString() ?? '',
      capacidadKVA: map['CapacidadKVA'] is double
          ? map['CapacidadKVA']
          : double.tryParse(map['Capacidad KVA']?.toString() ?? '0') ?? 0,
      consecutivo: map['Consecutivo'] is int
          ? map['Consecutivo']
          : int.tryParse(map['Consecutivo']?.toString() ?? '0') ?? 0,
      fecha_de_llegada: _parseFechaDMY(map['Fecha_de_llegada'] as String?),
      fases: map['Fase'] is int
          ? map['Fase']
          : int.tryParse(map['Fase']?.toString() ?? '0') ?? 0,
      serie: map['Serie']?.toString() ?? '',
      mes: map['Mes']?.toString() ?? '',
      marca: map['Marca']?.toString() ?? '',
      aceite: map['Aceite']?.toString() ?? '',
      peso_placa_de_datos: map['Peso_placa_de_datos']?.toString() ?? '',
      fecha_fabricacion: _parseFechaDMY(map['Fecha_fabricacion'] as String?),
      fecha_prueba: _parseFechaDMY(map['Fecha_prueba'] as String?),
      valor_prueba_1: map['Valor_prueba_1']?.toString() ?? '',
      valor_prueba_2: map['Valor_prueba_2']?.toString() ?? '',
      valor_prueba_3: map['Valor_prueba_3']?.toString() ?? '',
      resistencia_aislamiento_megaoms: map['Resistencia_aislamiento_megaoms'] is int
          ? map['Resistencia_aislamiento_megaoms']
          : int.tryParse(map['Resistencia_aislamiento_megaoms']?.toString() ?? '0') ?? 0,
      rigidez_dielecrica_kv: map['Rigidez_dielecrica_kv']?.toString() ?? '',
      estado: map['Estado']?.toString() ?? '',
      fecha_de_entrada_al_taller: _parseFechaDMY(map['Fecha_de_entrada_al_taller'] as String?),
      fecha_de_salida_del_taller: _parseFechaDMY(map['Fecha_de_salida_del_taller'] as String?),
      fecha_entrega_almacen: _parseFechaDMY(map['Fecha_entrega_almacen'] as String?),
      salida_mantenimiento: map['Salida_mantenimiento']?.toString() ?? '',
      fecha_salida_mantenimiento: _parseFechaDMY(map['Fecha_salida_mantenimiento'] as String?),
      baja: map['Baja']?.toString() ?? '',
      cargas: map['Cargas'] is int
          ? map['Cargas']
          : int.tryParse(map['Cargas']?.toString() ?? '0') ?? 0,
      area_fecha_de_entrega_transformador_reparado: map['Aerea_fecha_de_entrega_transformador_reparado']?.toString() ?? '',
    );
  }
}