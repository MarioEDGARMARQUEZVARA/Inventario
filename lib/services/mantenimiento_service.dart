import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart' as mantenimiento_model;
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart' as xzona_model;
import 'package:inventario_proyecto/models/motivo.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/// Obtener el próximo número de mantenimiento disponible
Future<int> _obtenerProximoNumeroMantenimiento() async {
  final snapshot = await FirebaseFirestore.instance
      .collection("mantenimiento2025")
      .orderBy("numero_mantenimiento", descending: true)
      .limit(1)
      .get();
  
  if (snapshot.docs.isEmpty) {
    return 1; // Primer mantenimiento
  }
  
  final ultimoNumero = snapshot.docs.first.data()['numero_mantenimiento'] as int?;
  return (ultimoNumero ?? 0) + 1;
}

/// Método para enviar a mantenimiento desde otras pantallas - VERSIÓN MEJORADA CON CONTADORES
Future<int> enviarAMantenimientoDesdeOtraPantalla(Map<String, dynamic> datosTransformador, String motivo) async {
  try {
    final proximoNumero = await _obtenerProximoNumeroMantenimiento();
    
    // Función auxiliar para parsear fechas seguras
    DateTime? _parsearFecha(dynamic fecha) {
      if (fecha == null) return null;
      if (fecha is DateTime) return fecha;
      if (fecha is Timestamp) return fecha.toDate();
      if (fecha is String) {
        try {
          return DateTime.parse(fecha);
        } catch (e) {
          return null;
        }
      }
      return null;
    }
    
    // Obtener contador actual de envíos a mantenimiento
    int contadorActual = datosTransformador['contadorEnviosMantenimiento'] ?? 0;
    
    final mantenimiento = mantenimiento_model.Mantenimiento(
      area: datosTransformador['area']?.toString() ?? datosTransformador['zona']?.toString() ?? '',
      capacidadKVA: (datosTransformador['capacidadKVA'] is num) 
          ? (datosTransformador['capacidadKVA'] as num).toDouble() 
          : double.tryParse(datosTransformador['capacidadKVA']?.toString() ?? '') ?? 0.0,
      economico: datosTransformador['economico']?.toString() ?? '',
      estado: 'en mantenimiento',
      fases: (datosTransformador['fases'] is int) 
          ? datosTransformador['fases'] as int 
          : int.tryParse(datosTransformador['fases']?.toString() ?? '') ?? 0,
      fecha_de_entrada_al_taller: DateTime.now(),
      fecha_prueba_1: DateTime.now(),
      fecha_prueba_2: DateTime.now(),
      fecha_de_alta: DateTime.now(),
      fecha_de_salida_del_taller: null,
      fecha_fabricacion: _parsearFecha(datosTransformador['fecha_fabricacion']) ?? 
                        _parsearFecha(datosTransformador['fechaMovimiento']) ?? 
                        DateTime.now(),
      peso_placa_de_datos: datosTransformador['peso_placa_de_datos']?.toString() ?? '',
      aceite: datosTransformador['aceite']?.toString() ?? '',
      marca: datosTransformador['marca']?.toString() ?? '',
      numero_mantenimiento: proximoNumero, // ASIGNAR NÚMERO AUTOMÁTICO
      resistencia_aislamiento_megaoms: (datosTransformador['resistencia_aislamiento_megaoms'] is int) 
          ? datosTransformador['resistencia_aislamiento_megaoms'] as int 
          : int.tryParse(datosTransformador['resistencia_aislamiento_megaoms']?.toString() ?? '') ?? 0,
      rigidez_dielecrica_kv: datosTransformador['rigidez_dielecrica_kv']?.toString() ?? '',
      serie: datosTransformador['serie']?.toString() ?? '',
      motivo: motivo,
      enviadoMantenimiento: true,
      fechaEnvioMantenimiento: DateTime.now(),
      // Campos específicos de transformadores x zona
      zona: datosTransformador['zona']?.toString(),
      relacion: (datosTransformador['relacion'] is int) 
          ? datosTransformador['relacion'] as int 
          : int.tryParse(datosTransformador['relacion']?.toString() ?? ''),
      fechaMovimiento: _parsearFecha(datosTransformador['fechaMovimiento']),
      reparado: datosTransformador['reparado'] is bool ? datosTransformador['reparado'] as bool : null,
      // Campos adicionales que pueden venir de transformadores actuales
      mes: datosTransformador['mes']?.toString(),
      consecutivo: (datosTransformador['consecutivo'] is int) 
          ? datosTransformador['consecutivo'] as int 
          : int.tryParse(datosTransformador['consecutivo']?.toString() ?? ''),
      fecha_de_llegada: _parsearFecha(datosTransformador['fecha_de_llegada']),
      fecha_entrega_almacen: _parsearFecha(datosTransformador['fecha_entrega_almacen']),
      salida_mantenimiento: datosTransformador['salida_mantenimiento'] is bool 
          ? datosTransformador['salida_mantenimiento'] as bool 
          : null,
      fecha_salida_mantenimiento: _parsearFecha(datosTransformador['fecha_salida_mantenimiento']),
      baja: datosTransformador['baja'] is bool ? datosTransformador['baja'] as bool : null,
      cargas: (datosTransformador['cargas'] is int) 
          ? datosTransformador['cargas'] as int 
          : int.tryParse(datosTransformador['cargas']?.toString() ?? ''),
      area_fecha_de_entrega_transformador_reparado: datosTransformador['area_fecha_de_entrega_transformador_reparado']?.toString(),
      // Campos de pruebas
      valor_prueba_1: datosTransformador['valor_prueba_1']?.toString(),
      valor_prueba_2: datosTransformador['valor_prueba_2']?.toString(),
      valor_prueba_3: datosTransformador['valor_prueba_3']?.toString(),
      rt_fase_a: (datosTransformador['rt_fase_a'] is num) 
          ? (datosTransformador['rt_fase_a'] as num).toDouble() 
          : double.tryParse(datosTransformador['rt_fase_a']?.toString() ?? ''),
      rt_fase_b: (datosTransformador['rt_fase_b'] is num) 
          ? (datosTransformador['rt_fase_b'] as num).toDouble() 
          : double.tryParse(datosTransformador['rt_fase_b']?.toString() ?? ''),
      rt_fase_c: (datosTransformador['rt_fase_c'] is num) 
          ? (datosTransformador['rt_fase_c'] as num).toDouble() 
          : double.tryParse(datosTransformador['rt_fase_c']?.toString() ?? ''),
      // NUEVO: Incluir contador de envíos
      contador: contadorActual + 1,
    );
    
    await db.collection("mantenimiento2025").add(mantenimiento.toJson());
    return 200;
  } catch (e) {
    print("Error al enviar a mantenimiento: $e");
    return 500;
  }
}

/// Obtener lista de mantenimiento
Future<List<mantenimiento_model.Mantenimiento>> getMantenimientos() async {
  QuerySnapshot query = await db.collection("mantenimiento2025").get();
  return query.docs.map((doc) {
    try {
      final raw = doc.data();
      print('getMantenimientos doc.id=${doc.id} data=$raw');
      final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
      var mantenimiento = mantenimiento_model.Mantenimiento.fromMap(data);
      mantenimiento.id = doc.id;
      return mantenimiento;
    } catch (e) {
      print('getMantenimientos parse error for doc ${doc.id}: $e');
      return _createDefaultMantenimiento();
    }
  }).toList();
}

/// Marcar como reparado y enviar a destino adaptándose al modelo correspondiente CON CONTADOR
Future<int> marcarReparado(String id, {String? destinoManual, mantenimiento_model.Mantenimiento? mantenimiento}) async {
  int code = 0;
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    
    // Si no se proporciona el mantenimiento, obtenerlo de la base de datos
    mantenimiento_model.Mantenimiento? datosMantenimiento = mantenimiento;
    if (datosMantenimiento == null) {
      final doc = await db.collection("mantenimiento2025").doc(id).get();
      if (doc.exists) {
        datosMantenimiento = mantenimiento_model.Mantenimiento.fromMap(doc.data()!);
        datosMantenimiento.id = doc.id;
      }
    }

    if (datosMantenimiento == null) {
      return 404; // No encontrado
    }

    // Obtener contador actual de reparaciones
    int contadorReparaciones = datosMantenimiento.contadorReparaciones;

    final destino = destinoManual ?? "transformadores2025";

    // 1. Marcar como reparado en mantenimiento CON CONTADOR
    await db.collection("mantenimiento2025").doc(id).update({
      "estado": "reparado",
      "fechaReparacion": Timestamp.now(),
      "destinoReparado": destino,
      "contadorReparaciones": contadorReparaciones + 1, // INCREMENTAR CONTADOR
    });

    // 2. Preparar datos según el destino
    if (destino == "transformadores2025") {
      await _enviarATransformadoresActuales(datosMantenimiento);
    } else if (destino == "transformadoresxzona") {
      await _enviarATransformadoresXZona(datosMantenimiento);
    }

    // 3. Eliminar el mantenimiento después de enviarlo a su destino
    await db.collection("mantenimiento2025").doc(id).delete();

    code = 200;
  } catch (e) {
    print("Error al marcar como reparado: $e");
    code = 500;
  }
  return code;
}

/// Enviar a Transformadores Actuales (modelo Tranformadoresactuales) CON CONTADOR - MEJORADO
Future<void> _enviarATransformadoresActuales(mantenimiento_model.Mantenimiento mantenimiento) async {
  // Verificar si ya existe un transformador con la misma serie
  final querySnapshot = await db
      .collection("transformadores2025")
      .where("Serie", isEqualTo: mantenimiento.serie)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Actualizar el transformador existente
    final existingDoc = querySnapshot.docs.first;
    await db.collection("transformadores2025").doc(existingDoc.id).update({
      'estado': 'reparado',
      'fecha_de_entrada_al_taller': DateTime.now(),
      'fecha_de_salida_del_taller': DateTime.now(),
      'fecha_entrega_almacen': DateTime.now(),
      'contadorEnviosMantenimiento': mantenimiento.contador,
      'enviadoMantenimiento': false,
      'reparado': true,
    });
    print("✅ Transformador existente actualizado: ${mantenimiento.serie}");
  } else {
    // Crear nuevo transformador si no existe
    final consecutivo = await _obtenerNuevoConsecutivo();
    
    final transformadorActual = Tranformadoresactuales(
      area: mantenimiento.area,
      consecutivo: consecutivo,
      fecha_de_llegada: mantenimiento.fecha_de_entrada_al_taller ?? DateTime.now(),
      mes: mantenimiento.mes ?? _obtenerMesActual(),
      marca: mantenimiento.marca,
      aceite: mantenimiento.aceite,
      economico: mantenimiento.economico,
      capacidadKVA: mantenimiento.capacidadKVA ?? 0.0,
      fases: mantenimiento.fases,
      serie: mantenimiento.serie,
      peso_placa_de_datos: mantenimiento.peso_placa_de_datos,
      fecha_fabricacion: mantenimiento.fecha_fabricacion ?? DateTime.now(),
      fecha_prueba: DateTime.now(),
      valor_prueba_1: mantenimiento.valor_prueba_1 ?? '',
      valor_prueba_2: mantenimiento.valor_prueba_2 ?? '',
      valor_prueba_3: mantenimiento.valor_prueba_3 ?? '',
      resistencia_aislamiento_megaoms: mantenimiento.resistencia_aislamiento_megaoms,
      rigidez_dielecrica_kv: mantenimiento.rigidez_dielecrica_kv,
      estado: "reparado",
      fecha_de_entrada_al_taller: mantenimiento.fecha_de_entrada_al_taller ?? DateTime.now(),
      fecha_de_salida_del_taller: mantenimiento.fecha_de_salida_del_taller ?? DateTime.now(),
      fecha_entrega_almacen: DateTime.now(),
      salida_mantenimiento: false,
      fecha_salida_mantenimiento: null,
      baja: false,
      cargas: mantenimiento.cargas ?? 0,
      area_fecha_de_entrega_transformador_reparado: mantenimiento.area_fecha_de_entrega_transformador_reparado ?? '',
      motivo: mantenimiento.motivo,
      motivos: mantenimiento.motivos,
      enviadoMantenimiento: false,
      fechaEnvioMantenimiento: null,
      // NUEVO: Mantener el contador de envíos a mantenimiento
      contadorEnviosMantenimiento: mantenimiento.contador,
    );

    await db.collection("transformadores2025").add(transformadorActual.toJson());
    print("✅ Nuevo transformador creado: ${mantenimiento.serie}");
  }
}

/// Enviar a Transformadores por Zona (modelo TransformadoresXZona) CON CONTADOR
Future<void> _enviarATransformadoresXZona(mantenimiento_model.Mantenimiento mantenimiento) async {
  // Verificar si ya existe un transformador con la misma serie en la misma zona
  final querySnapshot = await db
      .collection("transformadoresxzona")
      .where("Numero_de_serie", isEqualTo: mantenimiento.serie)
      .where("Zona", isEqualTo: mantenimiento.zona ?? '')
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Actualizar el transformador existente en lugar de crear uno nuevo
    final existingDoc = querySnapshot.docs.first;
    await db.collection("transformadoresxzona").doc(existingDoc.id).update({
      'Estado': 'Reparado',
      'Reparado': true,
      'Fecha_mov': DateTime.now(),
      'contadorEnviosMantenimiento': mantenimiento.contador,
      'enviadoMantenimiento': false,
    });
    print("✅ Transformador existente actualizado en zona: ${mantenimiento.zona}");
  } else {
    // Crear nuevo transformador si no existe
    final transformadorXZona = xzona_model.TransformadoresXZona(
      zona: mantenimiento.zona ?? '',
      economico: int.tryParse(mantenimiento.economico) ?? 0,
      marca: mantenimiento.marca,
      capacidadKVA: mantenimiento.capacidadKVA ?? 0.0,
      fases: mantenimiento.fases,
      serie: mantenimiento.serie,
      aceite: mantenimiento.aceite,
      peso_placa_de_datos: mantenimiento.peso_placa_de_datos,
      relacion: mantenimiento.relacion ?? 0,
      estado: "Reparado",
      fechaMovimiento: DateTime.now(),
      reparado: true,
      motivo: mantenimiento.motivo,
      enviadoMantenimiento: false,
      fechaEnvioMantenimiento: null,
      // NUEVO: Mantener el contador de envíos a mantenimiento
      contadorEnviosMantenimiento: mantenimiento.contador,
    );

    await db.collection("transformadoresxzona").add(transformadorXZona.toJson());
    print("✅ Nuevo transformador creado en zona: ${mantenimiento.zona}");
  }
}

/// CRUD
Future<int> addMantenimiento(mantenimiento_model.Mantenimiento m) async {
  try {
    // Si no tiene número de mantenimiento, asignar uno automático
    if (m.numero_mantenimiento == 0) {
      final proximoNumero = await _obtenerProximoNumeroMantenimiento();
      m.numero_mantenimiento = proximoNumero;
    }
    
    await db.collection("mantenimiento2025").add(m.toJson());
    return 200;
  } catch (e) {
    print("Error al agregar mantenimiento: $e");
    return 500;
  }
}

Future<int> updateMantenimiento(mantenimiento_model.Mantenimiento m) async {
  try {
    await db.collection("mantenimiento2025").doc(m.id).set(m.toJson());
    return 200;
  } catch (e) {
    return 500;
  }
}

Future<int> deleteMantenimiento(String id) async {
  try {
    await db.collection("mantenimiento2025").doc(id).delete();
    return 200;
  } catch (e) {
    return 500;
  }
}

/// Stream
Stream<List<mantenimiento_model.Mantenimiento>> mantenimientosStream() {
  return db.collection("mantenimiento2025").snapshots().map((snapshot) =>
      snapshot.docs.map((doc) {
        try {
          final raw = doc.data();
          print('mantenimientosStream doc.id=${doc.id} data=$raw');
          final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
          var mantenimiento = mantenimiento_model.Mantenimiento.fromMap(data);
          mantenimiento.id = doc.id;
          return mantenimiento;
        } catch (e) {
          print('mantenimientosStream parse error for doc ${doc.id}: $e');
          return _createDefaultMantenimiento();
        }
      }).toList());
}

/// Método auxiliar para crear Mantenimiento por defecto
mantenimiento_model.Mantenimiento _createDefaultMantenimiento() {
  return mantenimiento_model.Mantenimiento(
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
    peso_placa_de_datos: '',
    aceite: '',
    marca: '',
    numero_mantenimiento: 0,
    resistencia_aislamiento_megaoms: 0,
    rigidez_dielecrica_kv: '',
    serie: '',
    fecha_prueba_1: DateTime(1900),
    fecha_prueba_2: DateTime(1900),
    contadorReparaciones: 0,
  );
}

/// Métodos auxiliares
Future<int> _obtenerNuevoConsecutivo() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('transformadores2025')
      .get();
  return snapshot.docs.length + 1;
}

String _obtenerMesActual() {
  final meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];
  return meses[DateTime.now().month - 1];
}

Future<void> exportMantenimientosToExcel(BuildContext context) async {
  var status = await Permission.manageExternalStorage.request();
  if (!status.isGranted) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permiso de almacenamiento denegado')),
    );
    openAppSettings();
    return;
  }
  
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Pagina 1'];

  List<String> headers = [
    'Numero de mantenimiento', 'Fecha de llegada', 'Área', 'Económico', 'Marca', 
    'Capacidad', 'Fases', 'Serie', 'Litros', 'Kilos', 'Fecha de fabricación', 
    'Fecha de prueba', 'RT Fase A', 'RT Fase B', 'RT Fase C', 
    'Resistencia de aislamiento', 'Rigidez dieléctrica', 'Estado', 
    'Fecha de alta', 'Fecha de salida', 'Motivo', 'Fecha Reparación', 
    'Destino Reparado', 'Enviado a Mantenimiento', 'Fecha Envío Mantenimiento',
    'Veces Reparado', 'Contador Mantenimiento' // NUEVOS CAMPOS
  ];
  
  for (int i = 0; i < headers.length; i++) {
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        .value = TextCellValue(headers[i]);
  }

  var items = await getMantenimientos();

  for (int i = 0; i < items.length; i++) {
    var item = items[i];
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1)).value = TextCellValue(item.numero_mantenimiento?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1)).value = TextCellValue(item.fecha_de_entrada_al_taller?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1)).value = TextCellValue(item.area);
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1)).value = TextCellValue(item.economico);
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 1)).value = TextCellValue(item.marca);
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i + 1)).value = TextCellValue(item.capacidadKVA.toString());
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i + 1)).value = TextCellValue(item.fases.toString());
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: i + 1)).value = TextCellValue(item.serie);
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: i + 1)).value = TextCellValue(item.aceite);
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: i + 1)).value = TextCellValue(item.peso_placa_de_datos);
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: i + 1)).value = TextCellValue(item.fecha_fabricacion?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: i + 1)).value = TextCellValue(item.fecha_prueba?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: i + 1)).value = TextCellValue(item.rt_fase_a?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: i + 1)).value = TextCellValue(item.rt_fase_b?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: i + 1)).value = TextCellValue(item.rt_fase_c?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: i + 1)).value = TextCellValue(item.resistencia_aislamiento_megaoms.toString());
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 16, rowIndex: i + 1)).value = TextCellValue(item.rigidez_dielecrica_kv);
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 17, rowIndex: i + 1)).value = TextCellValue(item.estado);
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 18, rowIndex: i + 1)).value = TextCellValue(item.fecha_de_alta?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 19, rowIndex: i + 1)).value = TextCellValue(item.fecha_de_salida_del_taller?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 20, rowIndex: i + 1)).value = TextCellValue(item.motivo ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 21, rowIndex: i + 1)).value = TextCellValue(item.fechaReparacion?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 22, rowIndex: i + 1)).value = TextCellValue(item.destinoReparado ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 23, rowIndex: i + 1)).value = TextCellValue(item.enviadoMantenimiento.toString());
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 24, rowIndex: i + 1)).value = TextCellValue(item.fechaEnvioMantenimiento?.toString() ?? '');
    // NUEVOS CAMPOS
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 25, rowIndex: i + 1)).value = TextCellValue(item.contadorReparaciones.toString());
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 26, rowIndex: i + 1)).value = TextCellValue(item.contador.toString());
  }

  String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  String filePath = '/storage/emulated/0/Download/mantenimiento_$formattedDate.xlsx';

  List<int>? fileBytes = excel.save();
  if (fileBytes != null) {
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Archivo Excel guardado en: $filePath')),
    );
  }
}