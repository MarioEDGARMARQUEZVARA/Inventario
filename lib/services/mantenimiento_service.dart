import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:inventario_proyecto/models/motivo.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
FirebaseFirestore db = FirebaseFirestore.instance;

/// Obtener lista de mantenimiento
Future<List<Mantenimiento>> getMantenimientos() async {
  QuerySnapshot query = await db.collection("mantenimiento2025").get();
  return query.docs.map((doc) {
    try {
      final raw = doc.data();
      print('getMantenimientos doc.id=${doc.id} data=$raw');
      final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
      var mantenimiento = Mantenimiento.fromMap(data);
      mantenimiento.id = doc.id;
      return mantenimiento;
    } catch (e) {
      print('getMantenimientos parse error for doc ${doc.id}: $e');
      return Mantenimiento(
        area: '',
        capacidad: 0.0,
        economico: '',
        estado: '',
        fases: 0,
        fecha_de_alta: null,
        fecha_de_salida: null,
        fecha_fabricacion: null,
        fecha_llegada: null,
        fecha_prueba: RangoFecha(inicio: null, fin: null),
        kilos: '',
        litros: '',
        marca: '',
        numero_mantenimiento: 0,
        resistencia_aislamiento: 0,
        rigidez_dieletrica: '',
        serie: '',
      );
    }
  }).toList();
}

/// Marcar como reparado y devolver al origen
Future<int> marcarReparado(String id, {String? destinoManual}) async {
  int code = 0;
  try {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await db.collection("mantenimiento2025").doc(id).get();

    if (doc.exists) {
      Map<String, dynamic>? data = doc.data();
      String? origen = data?["origen"];

      // Decidir destino
      String destino;
      if (origen == "transformadores2025" || origen == "Transformadoresxzona") {
        destino = origen!;
      } else if (destinoManual != null) {
        destino = destinoManual; // Elegido manualmente
      } else {
        return 400; // Falta decidir destino
      }

      // Copiar a destino
      await db.collection(destino).add(data!);

      // Eliminar de mantenimiento
      await db.collection("mantenimiento2025").doc(id).delete();

      code = 200;
    } else {
      code = 404;
    }
  } catch (_) {
    code = 500;
  }
  return code;
}

/// CRUD
Future<int> addMantenimiento(Mantenimiento m) async {
  try {
    await db.collection("mantenimiento2025").add(m.toJson());
    return 200;
  } catch (e) {
    return 500;
  }
}

Future<int> updateMantenimiento(Mantenimiento m) async {
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
Stream<List<Mantenimiento>> mantenimientosStream() {
  return db.collection("mantenimiento2025").snapshots().map((snapshot) =>
      snapshot.docs.map((doc) {
        try {
          final raw = doc.data();
          print('mantenimientosStream doc.id=${doc.id} data=$raw');
          final data = raw as Map<String, dynamic>? ?? <String, dynamic>{};
          var mantenimiento = Mantenimiento.fromMap(data);
          mantenimiento.id = doc.id;
          return mantenimiento;
        } catch (e) {
          print('mantenimientosStream parse error for doc ${doc.id}: $e');
          return Mantenimiento(
            area: '',
            capacidad: 0.0,
            economico: '',
            estado: '',
            fases: 0,
            fecha_de_alta: null,
            fecha_de_salida: null,
            fecha_fabricacion: null,
            fecha_llegada: null,
            fecha_prueba: RangoFecha(inicio: null, fin: null),
            kilos: '',
            litros: '',
            marca: '',
            numero_mantenimiento: 0,
            resistencia_aislamiento: 0,
            rigidez_dieletrica: '',
            serie: '',
          );
        }
      }).toList());
}
Future<void> exportMantenimientosToExcel(BuildContext context) async {
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

  List<String> headers = ['Numero de mantenimiento', 'Fecha de llegada', 'Área', 'Económico', 'Marca', 'Capacidad', 'Fases', 'Serie', 'Litros', 'Kilos', 'Fecha de fabricación', 'Fecha de prueba', 'RT Fase A', 'RT Fase B', 'RT Fase C', 'Resistencia de aislamiento', 'Rigidez dieléctrica', 'Estado', 'Fecha de alta', 'Fecha de salida', 'Motivo'];
  for (int i = 0; i < headers.length; i++) {
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
        .value = TextCellValue(headers[i]);
  }

  var items = await getMantenimientos();

  for (int i = 0; i < items.length; i++) {
    var item = items[i];
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1)).value = TextCellValue(item.numero_mantenimiento?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1)).value = TextCellValue(item.fecha_llegada?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1)).value = TextCellValue(item.area ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1)).value = TextCellValue(item.economico ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 1)).value = TextCellValue(item.marca ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i + 1)).value = TextCellValue(item.capacidad?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i + 1)).value = TextCellValue(item.fases?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: i + 1)).value = TextCellValue(item.serie ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: i + 1)).value = TextCellValue(item.litros ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: i + 1)).value = TextCellValue(item.kilos ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: i + 1)).value = TextCellValue(item.fecha_fabricacion?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: i + 1)).value = TextCellValue(item.fecha_prueba?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: i + 1)).value = TextCellValue(item.rt_fase_a.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: i + 1)).value = TextCellValue(item.rt_fase_b.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: i + 1)).value = TextCellValue(item.rt_fase_c.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: i + 1)).value = TextCellValue(item.resistencia_aislamiento?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 16, rowIndex: i + 1)).value = TextCellValue(item.rigidez_dieletrica ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 17, rowIndex: i + 1)).value = TextCellValue(item.estado ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 18, rowIndex: i + 1)).value = TextCellValue(item.fecha_de_alta.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 19, rowIndex: i + 1)).value = TextCellValue(item.fecha_de_salida?.toString() ?? '');
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 20, rowIndex: i + 1)).value = TextCellValue(item.motivo ?? '');

    

  }

  String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  String filePath =
      '/storage/emulated/0/Download/mantenimiento_$formattedDate.xlsx';

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

