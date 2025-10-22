import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:inventario_proyecto/screens/mantenimiento_update.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/widgets/motivos_list.dart';
import 'package:inventario_proyecto/models/motivo.dart';

class MantenimientoOperationsScreen extends StatelessWidget {
  final Mantenimiento mantenimiento;
  const MantenimientoOperationsScreen({super.key, required this.mantenimiento});

  String _formatFecha(DateTime? fecha) {
    if (fecha == null) return "N/A";
    return "${fecha.day.toString().padLeft(2, '0')}/"
           "${fecha.month.toString().padLeft(2, '0')}/"
           "${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1AFF),
        title: const Text('Mantenimiento', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mantenimiento.numero_mantenimiento != 0) Text('Número mantenimiento: ${mantenimiento.numero_mantenimiento}'),
              if (mantenimiento.area.isNotEmpty) Text('Área: ${mantenimiento.area}'),
              if (mantenimiento.marca.isNotEmpty) Text('Marca: ${mantenimiento.marca}'),
              if (mantenimiento.fecha_llegada != null) Text('Fecha de llegada: ${_formatFecha(mantenimiento.fecha_llegada)}'),
              if (mantenimiento.economico.isNotEmpty) Text('Económico: ${mantenimiento.economico}'),
              if (mantenimiento.capacidad != 0) Text('Capacidad: ${mantenimiento.capacidad}'),
              if (mantenimiento.fases != 0) Text('Fases: ${mantenimiento.fases}'),
              if (mantenimiento.serie.isNotEmpty) Text('Serie: ${mantenimiento.serie}'),
              if (mantenimiento.litros.isNotEmpty) Text('Litros de aceite: ${mantenimiento.litros}'),
              if (mantenimiento.kilos.isNotEmpty) Text('Kilos: ${mantenimiento.kilos}'),
              if (mantenimiento.fecha_fabricacion != null) Text('Fecha de fabricación: ${_formatFecha(mantenimiento.fecha_fabricacion)}'),
              if (mantenimiento.fecha_prueba != null) Text('Fecha de prueba: ${_formatFecha(mantenimiento.fecha_prueba?.inicio)} - ${_formatFecha(mantenimiento.fecha_prueba?.fin)}'),
              if (mantenimiento.rt_fase_a != null) Text('RT. FASE A: ${mantenimiento.rt_fase_a}'),
              if (mantenimiento.rt_fase_b != null) Text('RT. FASE B: ${mantenimiento.rt_fase_b}'),
              if (mantenimiento.rt_fase_c != null) Text('RT. FASE C: ${mantenimiento.rt_fase_c}'),
              if (mantenimiento.resistencia_aislamiento != 0) Text('Resistencia de Aislamiento: ${mantenimiento.resistencia_aislamiento}'),
              if (mantenimiento.rigidez_dieletrica.isNotEmpty) Text('Rigidez Dieléctrica: ${mantenimiento.rigidez_dieletrica}'),
              const SizedBox(height: 12),

              // Reemplazado por widget reutilizable
              MotivosList(collectionPath: 'mantenimiento2025', docId: mantenimiento.id ?? ''),

              const SizedBox(height: 24),

              // Eliminar
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await deleteMantenimiento(mantenimiento.id ?? '');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mantenimiento eliminado')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 12),

              // Actualizar
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2A1AFF)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MantenimientoUpdateScreen(mantenimiento: mantenimiento),
                    ),
                  );
                },
                child: const Text('Actualizar', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 12),

              // Exportar
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async{
                  await exportMantenimientosToExcel(context);
                },
                child: const Text('Exportar a xlsx', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 12),

              // Marcar como reparado
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                onPressed: () async {
                  await _marcarReparado(context);
                },
                child: const Text("Marcar como reparado", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _marcarReparado(BuildContext context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final mantenimientoId = mantenimiento.id ?? '';
    final mantenimientoData = mantenimiento.toJson();

    String? origen = mantenimientoData["origen"];

    if (origen != null && origen.isNotEmpty) {
      await db.collection(origen).add({
        ...mantenimientoData,
        "estado": "reparado",
        "fechaReparacion": Timestamp.now(),
      });

      await db.collection("Mantenimiento").doc(mantenimientoId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transformador enviado a $origen")),
      );
    } else {
      String? destino = await _seleccionarDestino(context);

      if (destino != null) {
        await db.collection(destino).add({
          ...mantenimientoData,
          "estado": "reparado",
          "fechaReparacion": Timestamp.now(),
        });

        await db.collection("Mantenimiento").doc(mantenimientoId).delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Transformador enviado a $destino")),
        );
      }
    }
  }

  Future<String?> _seleccionarDestino(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Seleccionar destino"),
          content: const Text("¿A dónde quieres enviar este transformador?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, "transformadores2025"),
              child: const Text("Transformadores 2025"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, "transformadoresxzona"),
              child: const Text("Transformadores por Zona"),
            ),
          ],
        );
      },
    );
  }
}
