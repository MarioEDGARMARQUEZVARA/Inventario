import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
FirebaseFirestore db = FirebaseFirestore.instance;

/// Obtener lista de transformadores por zona
Future<List<TransformadoresXZona>> getTransformadoresxZona() async {
  QuerySnapshot query = await db.collection("Transformadoresxzona").get();
  return query.docs.map((doc) {
    // Debug: mostrar estructura real del documento antes del fromMap
    try {
      final raw = doc.data();
      print('getTransformadoresxZona doc.id=${doc.id} data=$raw');
      final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
      var transformador = TransformadoresXZona.fromMap(data);
      transformador.id = doc.id;
      return transformador;
    } catch (e) {
      print('getTransformadoresxZona parse error for doc ${doc.id}: $e');
      return TransformadoresXZona(
        id: doc.id,
        zona: '',
        numEconomico: 0,
        marca: '',
        capacidad: 0,
        fase: 0,
        numeroDeSerie: '',
        litros: '',
        pesoKg: '',
        relacion: 0,
        status: '',
        fechaMovimiento: null,
        reparado: false,
      );
    }
  }).toList();
}

/// Enviar transformador a mantenimiento con motivo
Future<int> enviarAMantenimientoZona(String id, String motivo) async {
  int code = 0;
  try {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await db.collection("Transformadoresxzona").doc(id).get();

    if (doc.exists) {
      Map<String, dynamic>? data = doc.data();

      // Guardamos también el origen
      data!["origen"] = "Transformadoresxzona";

      DocumentReference newDoc =
          await db.collection("mantenimiento2025").add(data);

      await newDoc.collection("motivos").add({
        "motivo": motivo,
        "fecha": FieldValue.serverTimestamp(), // <-- CORRECTO
      });

      await db.collection("Transformadoresxzona").doc(id).delete();

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
Future<int> addTransformador(TransformadoresXZona tz) async {
  try {
    await db.collection("Transformadoresxzona").add(tz.toJson());
    return 200;
  } catch (_) {
    return 500;
  }
}

Future<int> updateTransformador(TransformadoresXZona tz) async {
  try {
    await db.collection('Transformadoresxzona').doc(tz.id).set(tz.toJson());
    return 200;
  } catch (_) {
    return 500;
  }
}

Future<int> deleteTransformadorZona(String id) async {
  try {
    await db.collection('Transformadoresxzona').doc(id).delete();
    return 200;
  } catch (_) {
    return 500;
  }
}

/// Stream
Stream<List<TransformadoresXZona>> transformadoresxzonaStream() {
  return db.collection("Transformadoresxzona").snapshots().map((snapshot) =>
      snapshot.docs.map((doc) {
        try {
          final raw = doc.data();
          print('transformadoresxzonaStream doc.id=${doc.id} data=$raw');
          final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
          var transformador = TransformadoresXZona.fromMap(data);
          transformador.id = doc.id;
          return transformador;
        } catch (e) {
          print('transformadoresxzonaStream parse error for doc ${doc.id}: $e');
          return TransformadoresXZona(
            id: doc.id,
            zona: '',
            numEconomico: 0,
            marca: '',
            capacidad: 0,
            fase: 0,
            numeroDeSerie: '',
            litros: '',
            pesoKg: '',
            relacion: 0,
            status: '',
            fechaMovimiento: null,
            reparado: false,
          );
        }
      }).toList());
}
Future<void> exportTransformadoresxzonaToExcel(BuildContext context) async {
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

  List<String> headers = ['Zona', 'Economico', 'Marca', 'Capacidad', 'Fase', 'Numero de Serie', 'Litros', 'Kilos', 'Relación', 'Status', 'Fecha de Movimiento', 'Reparado', 'Motivo'];
  for (int i = 0; i < headers.length; i++) {
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        .value = TextCellValue(headers[i]);
  }

  var items = await getTransformadoresxZona();

  for (int i = 0; i < items.length; i++) {
    var item = items[i];
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1)).value = TextCellValue(item.zona?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1)).value = TextCellValue(item.numEconomico?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1)).value = TextCellValue(item.marca ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1)).value = TextCellValue(item.capacidad.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 1)).value = TextCellValue(item.fase?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i + 1)).value = TextCellValue(item.numeroDeSerie ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i + 1)).value = TextCellValue(item.litros ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: i + 1)).value = TextCellValue(item.pesoKg ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: i + 1)).value = TextCellValue(item.relacion?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: i + 1)).value = TextCellValue(item.status ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: i + 1)).value = TextCellValue(item.fechaMovimiento.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: i + 1)).value = TextCellValue(item.reparado.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: i + 1)).value = TextCellValue(item.motivo ?? '');

    

  }

  String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  String filePath =
      '/storage/emulated/0/Download/transformadoresxzona_$formattedDate.xlsx';

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

