import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';

class MantenimientoOperationsScreen extends StatelessWidget {
  final Mantenimiento mantenimiento;
  const MantenimientoOperationsScreen({super.key, required this.mantenimiento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1AFF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Mantenimiento', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Número de mantenimiento: ${mantenimiento.numero_mantenimiento}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Fecha de llegada: ${_formatFecha(mantenimiento.fecha_llegada)}'),
                    Text('Área: ${mantenimiento.area}'),
                    Text('Económico: ${mantenimiento.economico}'),
                    Text('Marca: ${mantenimiento.marca}'),
                    Text('Capacidad: ${mantenimiento.capacidad}'),
                    Text('Fases: ${mantenimiento.fases}'),
                    Text('Serie: ${mantenimiento.serie}'),
                    Text('Litros de aceite: ${mantenimiento.litros}'),
                    Text('Kilos: ${mantenimiento.kilos}'),
                    Text('Fecha de fabricación: ${_formatFecha(mantenimiento.fecha_fabricacion)}'),
                    Text('Fecha de prueba: ${_formatFecha(mantenimiento.fecha_prueba.inicio)} - ${_formatFecha(mantenimiento.fecha_prueba.fin)}'),
                    Text('RT. FASE A: ${mantenimiento.rt_fase_a?.toString() ?? "N.A."}'),
                    Text('RT. FASE B: ${mantenimiento.rt_fase_b?.toString() ?? "N.A."}'),
                    Text('RT. FASE C: ${mantenimiento.rt_fase_c?.toString() ?? "N.A."}'),
                    Text('Resistencia de Aislamiento: ${mantenimiento.resistencia_aislamiento}'),
                    Text('Rigidez Dieléctrica: ${mantenimiento.rigidez_dieletrica}'),
                    Text('Estado: ${mantenimiento.estado}'),
                    Text('Fecha de entrada: ${_formatFecha(mantenimiento.fecha_de_alta)}'),
                    Text('Fecha de salida: ${_formatFecha(mantenimiento.fecha_de_salida)}'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: () {},
                      child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2A1AFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: () {},
                      child: const Text('Actualizar', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: () {},
                      child: const Text('Exportar a xlsx', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFecha(DateTime fecha) {
    return "${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}";
  }
}
