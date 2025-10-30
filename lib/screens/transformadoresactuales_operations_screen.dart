import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';
import 'package:inventario_proyecto/screens/transformadoresactuales_update.dart';
import 'package:inventario_proyecto/services/transformadores_service.dart';
import 'package:inventario_proyecto/widgets/motivo_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/transformadores2025_provider.dart';

class TransformadoresActualesOperationsScreen extends StatelessWidget {
  final Tranformadoresactuales transformador;

  const TransformadoresActualesOperationsScreen({super.key, required this.transformador});

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Transformadores2025Provider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1AFF),
        title: const Text(
          'Transformadores 2025',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Consecutivo: ${transformador.consecutivo}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Fecha de llegada: ${_formatDate(transformador.fecha_de_llegada)}'),
            Text('Área: ${transformador.area}'),
            Text('Marca: ${transformador.marca}'),
            Text('Capacidad KVA: ${transformador.capacidadKVA}'),
            Text('Fecha de llegada: ${_formatDate(transformador.fecha_de_llegada)}'),
            Text('Mes: ${transformador.mes}'),
            Text('Área y fecha de entrega de transformador reparado: ${transformador.area_fecha_de_entrega_transformador_reparado}'),
            Text('Económico: ${transformador.economico}'),
            Text('Capacidad KVA: ${transformador.capacidadKVA}'),
            Text('Fases: ${transformador.fases}'),
            Text('Serie: ${transformador.serie}'),
            Text('Aceite: ${transformador.aceite}'),
            Text('Peso en placa de datos: ${transformador.peso_placa_de_datos}'),
            Text('Fecha de fabricación: ${_formatDate(transformador.fecha_fabricacion)}'),
            Text('Fecha de prueba: ${_formatDate(transformador.fecha_prueba)}'),
            Text('Valor de prueba 1: ${transformador.valor_prueba_1}'),
            Text('Valor de prueba 2: ${transformador.valor_prueba_2}'),
            Text('Valor de prueba 3: ${transformador.valor_prueba_3}'),
            Text('Resistencia de Aislamiento de megaoms: ${transformador.resistencia_aislamiento_megaoms}'),
            Text('Rigidez Dieléctrica: ${transformador.rigidez_dielecrica_kv}'),
            Text('Estado: ${transformador.estado}'),
            Text('Fecha de entrada: ${_formatDate(transformador.fecha_de_entrada_al_taller)}'),
            Text('Fecha de salida: ${_formatDate(transformador.fecha_de_salida_del_taller)}'),
            Text('Fecha de entrega: ${_formatDate(transformador.fecha_entrega_almacen)}'),
            Text('Salida a mantenimiento mayor: ${transformador.salida_mantenimiento ? "Sí" : "No"}'),
            Text('Fecha de salida a mantenimiento mayor: ${transformador.fecha_salida_mantenimiento != null ? _formatDate(transformador.fecha_salida_mantenimiento!) : "N/A"}'),
            Text('Baja: ${transformador.baja}'),
            Text('Cargas: ${transformador.cargas}'),
            const SizedBox(height: 24),

            // Eliminar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  if (transformador.id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error: El ID del transformador es nulo')),
                    );
                    return;
                  }
                  await provider.deleteTransformadorProvider(transformador.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transformador eliminado')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),

            // Actualizar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2A1AFF)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransformadoresActualesUpdateScreen(transformador: transformador),
                    ),
                  ).then((_) {
                    // Actualizar datos después de regresar de la actualización
                    provider.refreshData();
                  });
                },
                child: const Text('Actualizar', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),

            // Exportar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  await exportTransformadoresToExcel(context);
                },
                child: const Text('Exportar a xlsx', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),

            // Enviar a mantenimiento
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                onPressed: () async {
                  if (transformador.id == null) return;

                  final motivo = await mostrarMotivoDialog(context);
                  if (motivo != null && motivo.isNotEmpty) {
                    final result = await provider.enviarAMantenimientoProvider(transformador.id!, motivo);
                    if (result == 200) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enviado a mantenimiento')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error al enviar a mantenimiento')),
                      );
                    }
                  }
                },
                child: const Text('Enviar a mantenimiento', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}