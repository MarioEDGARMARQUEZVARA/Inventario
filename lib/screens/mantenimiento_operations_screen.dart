import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:inventario_proyecto/screens/mantenimiento_update.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/widgets/motivos_list.dart';
import 'package:inventario_proyecto/models/motivo.dart';
import 'package:provider/provider.dart';
import '../providers/mantenimento_provider.dart';

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
    final provider = Provider.of<MantenimientoProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1AFF),
        title:
            const Text('Mantenimiento', style: TextStyle(color: Colors.white)),
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
              if (mantenimiento.numero_mantenimiento != 0)
                Text(
                    'Número mantenimiento: ${mantenimiento.numero_mantenimiento}'),
              if (mantenimiento.area.isNotEmpty)
                Text('Área: ${mantenimiento.area}'),
              if (mantenimiento.marca.isNotEmpty)
                Text('Marca: ${mantenimiento.marca}'),
              if (mantenimiento.fecha_de_entrada_al_taller != null)
                Text(
                    'Fecha de llegada: ${_formatFecha(mantenimiento.fecha_de_entrada_al_taller)}'),
              if (mantenimiento.economico.isNotEmpty)
                Text('Económico: ${mantenimiento.economico}'),
              if (mantenimiento.capacidadKVA != 0)
                Text('Capacidad: ${mantenimiento.capacidadKVA}'),
              if (mantenimiento.fases != 0)
                Text('Fases: ${mantenimiento.fases}'),
              if (mantenimiento.serie.isNotEmpty)
                Text('Serie: ${mantenimiento.serie}'),
              if (mantenimiento.aceite.isNotEmpty)
                Text('Litros de aceite: ${mantenimiento.aceite}'),
              if (mantenimiento.peso_placa_de_datos.isNotEmpty)
                Text(
                    'Peso placa de datos: ${mantenimiento.peso_placa_de_datos}'),
              if (mantenimiento.fecha_fabricacion != null)
                Text(
                    'Fecha de fabricación: ${_formatFecha(mantenimiento.fecha_fabricacion)}'),
              if (mantenimiento.fecha_prueba != null)
                Text(
                    'Fecha de prueba: ${_formatFecha(mantenimiento.fecha_prueba?.inicio)} - ${_formatFecha(mantenimiento.fecha_prueba?.fin)}'),
              if (mantenimiento.rt_fase_a != null)
                Text('RT. FASE A: ${mantenimiento.rt_fase_a}'),
              if (mantenimiento.rt_fase_b != null)
                Text('RT. FASE B: ${mantenimiento.rt_fase_b}'),
              if (mantenimiento.rt_fase_c != null)
                Text('RT. FASE C: ${mantenimiento.rt_fase_c}'),
              if (mantenimiento.resistencia_aislamiento_megaoms != 0)
                Text(
                    'Resistencia de Aislamiento: ${mantenimiento.resistencia_aislamiento_megaoms}'),
              if (mantenimiento.rigidez_dielecrica_kv.isNotEmpty)
                Text(
                    'Rigidez Dieléctrica: ${mantenimiento.rigidez_dielecrica_kv}'),
              if (mantenimiento.area.isNotEmpty)
                Text('Área: ${mantenimiento.area}'),
              if (mantenimiento.marca.isNotEmpty)
                Text('Marca: ${mantenimiento.marca}'),
              if (mantenimiento.fecha_de_entrada_al_taller != null)
                Text(
                    'Fecha de llegada: ${_formatFecha(mantenimiento.fecha_de_entrada_al_taller)}'),
              if (mantenimiento.fecha_de_alta != null)
                Text(
                    'Fecha de alta: ${_formatFecha(mantenimiento.fecha_de_alta)}'),
              if (mantenimiento.fecha_de_salida_del_taller != null)
                Text(
                    'Fecha de salida del taller: ${_formatFecha(mantenimiento.fecha_de_salida_del_taller)}'),
              if (mantenimiento.economico.isNotEmpty)
                Text('Económico: ${mantenimiento.economico}'),
              if (mantenimiento.numEconomico != null &&
                  mantenimiento.numEconomico != 0)
                Text('Número económico: ${mantenimiento.numEconomico}'),
              if (mantenimiento.capacidadKVA != 0)
                Text('Capacidad: ${mantenimiento.capacidadKVA} KVA'),
              if (mantenimiento.fases != 0)
                Text('Fases: ${mantenimiento.fases}'),
              if (mantenimiento.serie.isNotEmpty)
                Text('Serie: ${mantenimiento.serie}'),
              if (mantenimiento.aceite.isNotEmpty)
                Text('Litros de aceite: ${mantenimiento.aceite}'),
              if (mantenimiento.peso_placa_de_datos.isNotEmpty)
                Text(
                    'Peso placa de datos: ${mantenimiento.peso_placa_de_datos}'),
              if (mantenimiento.fecha_fabricacion != null)
                Text(
                    'Fecha de fabricación: ${_formatFecha(mantenimiento.fecha_fabricacion)}'),
              if (mantenimiento.fecha_prueba.inicio != null ||
                  mantenimiento.fecha_prueba.fin != null)
                Text(
                    'Fecha de prueba: ${_formatFecha(mantenimiento.fecha_prueba.inicio)} - ${_formatFecha(mantenimiento.fecha_prueba.fin)}'),
              if (mantenimiento.rt_fase_a != null)
                Text('RT Fase A: ${mantenimiento.rt_fase_a}'),
              if (mantenimiento.rt_fase_b != null)
                Text('RT Fase B: ${mantenimiento.rt_fase_b}'),
              if (mantenimiento.rt_fase_c != null)
                Text('RT Fase C: ${mantenimiento.rt_fase_c}'),
              if (mantenimiento.resistencia_aislamiento_megaoms != 0)
                Text(
                    'Resistencia de Aislamiento: ${mantenimiento.resistencia_aislamiento_megaoms} MΩ'),
              if (mantenimiento.rigidez_dielecrica_kv.isNotEmpty)
                Text(
                    'Rigidez Dieléctrica: ${mantenimiento.rigidez_dielecrica_kv} kV'),
              if (mantenimiento.estado.isNotEmpty)
                Text('Estado: ${mantenimiento.estado}'),
              if (mantenimiento.motivo != null &&
                  mantenimiento.motivo!.isNotEmpty)
                Text('Motivo: ${mantenimiento.motivo}'),
              if (mantenimiento.contador != 0)
                Text('Contador: ${mantenimiento.contador}'),
              if (mantenimiento.zona != null && mantenimiento.zona!.isNotEmpty)
                Text('Zona: ${mantenimiento.zona}'),
              if (mantenimiento.relacion != null && mantenimiento.relacion != 0)
                Text('Relación: ${mantenimiento.relacion}'),
              if (mantenimiento.status != null &&
                  mantenimiento.status!.isNotEmpty)
                Text('Status: ${mantenimiento.status}'),
              if (mantenimiento.fechaMovimiento != null)
                Text(
                    'Fecha de movimiento: ${_formatFecha(mantenimiento.fechaMovimiento)}'),
              if (mantenimiento.reparado != null)
                Text('Reparado: ${mantenimiento.reparado! ? "Sí" : "No"}'),
              if (mantenimiento.baja != null && mantenimiento.baja!.isNotEmpty)
                Text('Baja: ${mantenimiento.baja}'),
              if (mantenimiento.cargas != null && mantenimiento.cargas != 0)
                Text('Cargas: ${mantenimiento.cargas}'),
              if (mantenimiento.area_fecha_de_entrega_transformador_reparado !=
                      null &&
                  mantenimiento
                      .area_fecha_de_entrega_transformador_reparado!.isNotEmpty)
                Text(
                    'Área/Fecha entrega transformador reparado: ${mantenimiento.area_fecha_de_entrega_transformador_reparado}'),

              const SizedBox(height: 12),

              // Reemplazado por widget reutilizable
              MotivosList(
                  collectionPath: 'mantenimiento2025',
                  docId: mantenimiento.id ?? ''),

              const SizedBox(height: 24),

              // Eliminar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    await provider
                        .deleteMantenimientoProvider(mantenimiento.id ?? '');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mantenimiento eliminado')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Eliminar',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),

              // Actualizar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2A1AFF)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MantenimientoUpdateScreen(
                            mantenimiento: mantenimiento),
                      ),
                    ).then((_) {
                      // Actualizar datos después de regresar de la actualización
                      provider.refreshData();
                    });
                  },
                  child: const Text('Actualizar',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),

              // Exportar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    await exportMantenimientosToExcel(context);
                  },
                  child: const Text('Exportar a xlsx',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),

              // Marcar como reparado
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  onPressed: () async {
                    await _marcarReparado(context, provider);
                  },
                  child: const Text("Marcar como reparado",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _marcarReparado(
      BuildContext context, MantenimientoProvider provider) async {
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

      await provider.deleteMantenimientoProvider(mantenimientoId);

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

        await provider.deleteMantenimientoProvider(mantenimientoId);

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
