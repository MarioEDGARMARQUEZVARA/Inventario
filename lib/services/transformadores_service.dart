import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
FirebaseFirestore db = FirebaseFirestore.instance;

/// Obtener lista de transformadores actuales
Future<List<Tranformadoresactuales>> getTranformadoresActuales() async {
  CollectionReference coleccion = db.collection("transformadores2025");
  QuerySnapshot queryTransformadores = await coleccion.get();
  return queryTransformadores.docs.map((doc) {
    try {
      final raw = doc.data();
      print('getTranformadoresActuales doc.id=${doc.id} data=$raw');
      final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
      var transformador = Tranformadoresactuales.fromMap(data);
      transformador.id = doc.id;
      return transformador;
    } catch (e) {
      print('getTranformadoresActuales parse error for doc ${doc.id}: $e');
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
      );
    }
  }).toList();
}

/// Enviar transformador a mantenimiento con motivo
Future<int> enviarAMantenimiento(String id, String motivo) async {
  int code = 0;
  try {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await db.collection("transformadores2025").doc(id).get();

    if (doc.exists) {
      Map<String, dynamic>? data = doc.data();

      // Guardamos también el origen
      data!["origen"] = "transformadores2025";

      // Copiar registro a mantenimiento
      DocumentReference newDoc =
          await db.collection("mantenimiento2025").add(data);

      // Guardar motivo como subcolección
      await newDoc.collection("motivos").add({
        "motivo": motivo,
        "fecha": DateTime.now(),
      });

      // Eliminar de transformadores actuales
      await db.collection("transformadores2025").doc(id).delete();

      code = 200;
    } else {
      code = 404;
    }
  } catch (e) {
    code = 500;
  }
  return code;
}

/// CRUD
Future<int> addTransformador(Tranformadoresactuales ta) async {
  try {
    await db.collection("transformadores2025").add(ta.toJson());
    return 200;
  } catch (_) {
    return 500;
  }
}

Future<int> updateTransformador(Tranformadoresactuales ta) async {
  try {
    await db.collection('transformadores2025').doc(ta.id).set(ta.toJson());
    return 200;
  } catch (_) {
    return 500;
  }
}

Future<int> deleteTransformadorActual(String id) async {
  try {
    await db.collection('transformadores2025').doc(id).delete();
    return 200;
  } catch (_) {
    return 500;
  }
}

/// Stream
Stream<List<Tranformadoresactuales>> transformadoresActualesStream() {
  return db.collection("transformadores2025").snapshots().map((snapshot) =>
      snapshot.docs.map((doc) {
        try {
          final raw = doc.data();
          print('transformadoresActualesStream doc.id=${doc.id} data=$raw');
          final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
          var transformador = Tranformadoresactuales.fromMap(data);
          transformador.id = doc.id;
          return transformador;
        } catch (e) {
          print('transformadoresActualesStream parse error for doc ${doc.id}: $e');
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
          );
        }
      }).toList());
}
Future<void> exportTransformadoresToExcel(BuildContext context) async {
    var status = await Permission.manageExternalStorage.request();
  if (!status.isGranted) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permiso de almacenamiento denegado')),
    );
    openAppSettings(); // abrir ajustes si el usuario lo deniega
    return;
  }
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Pagina 1'];

  List<String> headers = ['Consecutivo', 'Fecha de llegada','Mes', 'Área', 'Económico', 'Marca', 'Capacidad KVA', 'Fases', 'Serie', 'Aceite', 'Peso en placa de datos', 'Fecha de fabricación', 'Fecha de prueba', 'Valor Prueba 1', 'Valor prueba 2', 'Valor prueba 3', 'Resistencia de aislamiento de megaohms', 'Rigidez dieléctrica kv', 'Estado', 'Fecha de entrada al taller', 'Fecha de salida del taller', 'Area a la que se entrega transformador reparado y fecha','Fecha de entrega al almacen','Salida a mantenimiento mayor','Fecha de salida a mantenimiento mayor','Baja','Cargas','Motivo'];
  for (int i = 0; i < headers.length; i++) {
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        .value = TextCellValue(headers[i]);
  }

  var items = await getTranformadoresActuales();

  for (int i = 0; i < items.length; i++) {
    var item = items[i];
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1)).value = TextCellValue(item.consecutivo?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1)).value = TextCellValue(item.fecha_de_llegada?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1)).value = TextCellValue(item.mes ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1)).value = TextCellValue(item.area ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 1)).value = TextCellValue(item.economico ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i + 1)).value = TextCellValue(item.marca ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i + 1)).value = TextCellValue(item.capacidadKVA?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: i + 1)).value = TextCellValue(item.fases?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: i + 1)).value = TextCellValue(item.serie ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: i + 1)).value = TextCellValue(item.aceite ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: i + 1)).value = TextCellValue(item.peso_placa_de_datos ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: i + 1)).value = TextCellValue(item.fecha_fabricacion?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: i + 1)).value = TextCellValue(item.fecha_prueba?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: i + 1)).value = TextCellValue(item.valor_prueba_1?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: i + 1)).value = TextCellValue(item.valor_prueba_2?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: i + 1)).value = TextCellValue(item.valor_prueba_3?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 16, rowIndex: i + 1)).value = TextCellValue(item.resistencia_aislamiento_megaoms?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 17, rowIndex: i + 1)).value = TextCellValue(item.rigidez_dielecrica_kv ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 18, rowIndex: i + 1)).value = TextCellValue(item.estado ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 19, rowIndex: i + 1)).value = TextCellValue(item.fecha_de_entrada_al_taller.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 20, rowIndex: i + 1)).value = TextCellValue(item.fecha_de_salida_del_taller?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 21, rowIndex: i + 1)).value = TextCellValue(item.area_fecha_de_entrega_transformador_reparado ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 22, rowIndex: i + 1)).value = TextCellValue(item.fecha_entrega_almacen?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 23, rowIndex: i + 1)).value = TextCellValue(item.salida_mantenimiento.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 24, rowIndex: i + 1)).value = TextCellValue(item.fecha_salida_mantenimiento?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 25, rowIndex: i + 1)).value = TextCellValue(item.baja ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 26, rowIndex: i + 1)).value = TextCellValue(item.cargas?.toString() ?? '');  
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 27, rowIndex: i + 1)).value = TextCellValue(item.motivo ?? '');

    

  }

  String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  String filePath =
      '/storage/emulated/0/Download/treansformadores_2025_$formattedDate.xlsx';

  List<int>? fileBytes = excel.save();
  if (fileBytes != null) {
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('El excel ha sido guardado en: $filePath')),
    );
  }
}

