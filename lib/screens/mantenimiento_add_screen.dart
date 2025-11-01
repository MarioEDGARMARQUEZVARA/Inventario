import 'package:flutter/material.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:intl/intl.dart';

class MantenimientoAddScreen extends StatefulWidget {
  const MantenimientoAddScreen({super.key});

  @override
  State<MantenimientoAddScreen> createState() => _MantenimientoAddScreenState();
}

class _MantenimientoAddScreenState extends State<MantenimientoAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final areaController = TextEditingController();
  final capacidadController = TextEditingController();
  final economicoController = TextEditingController();
  final estadoController = TextEditingController();
  final fasesController = TextEditingController();
  final pesoPlacaDeDatosController = TextEditingController();
  final litrosController = TextEditingController();
  final marcaController = TextEditingController();
  final numeroMantenimientoController = TextEditingController();
  final resistenciaAislamientoController = TextEditingController();
  final rigidezDieletricaController = TextEditingController();
  final rtFaseAController = TextEditingController();
  final rtFaseBController = TextEditingController();
  final rtFaseCController = TextEditingController();
  final serieController = TextEditingController();

  DateTime fechaAlta = DateTime.now();
  DateTime fechaSalida = DateTime.now();
  DateTime fechaFabricacion = DateTime.now();
  DateTime fechaLlegada = DateTime.now();
  DateTime fechaPruebaInicio = DateTime.now();
  DateTime fechaPruebaFin = DateTime.now();

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate, Function(DateTime) onSelected) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) onSelected(picked);
  }

  @override
  void dispose() {
    areaController.dispose();
    capacidadController.dispose();
    economicoController.dispose();
    estadoController.dispose();
    fasesController.dispose();
    pesoPlacaDeDatosController.dispose();
    litrosController.dispose();
    marcaController.dispose();
    numeroMantenimientoController.dispose();
    resistenciaAislamientoController.dispose();
    rigidezDieletricaController.dispose();
    rtFaseAController.dispose();
    rtFaseBController.dispose();
    rtFaseCController.dispose();
    serieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Mantenimiento'),
        backgroundColor: const Color(0xFF2A1AFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: numeroMantenimientoController,
                  decoration: const InputDecoration(
                    labelText: 'Número de mantenimiento',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context, fechaLlegada, (d) => setState(() => fechaLlegada = d)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de llegada',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(fechaLlegada)),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: areaController,
                  decoration: const InputDecoration(
                    labelText: 'Área',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: economicoController,
                  decoration: const InputDecoration(
                    labelText: 'Económico',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: marcaController,
                  decoration: const InputDecoration(
                    labelText: 'Marca',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: capacidadController,
                  decoration: const InputDecoration(
                    labelText: 'Capacidad',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: fasesController,
                  decoration: const InputDecoration(
                    labelText: 'Fases',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: serieController,
                  decoration: const InputDecoration(
                    labelText: 'Serie',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: litrosController,
                  decoration: const InputDecoration(
                    labelText: 'Litros de aceite',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: pesoPlacaDeDatosController,
                  decoration: const InputDecoration(
                    labelText: 'Kilos',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context, fechaFabricacion, (d) => setState(() => fechaFabricacion = d)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de fabricación',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(fechaFabricacion)),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, fechaPruebaInicio, (d) => setState(() => fechaPruebaInicio = d)),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Fecha prueba inicio',
                            border: OutlineInputBorder(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDate(fechaPruebaInicio)),
                              const Icon(Icons.calendar_today, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('-'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, fechaPruebaFin, (d) => setState(() => fechaPruebaFin = d)),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Fecha prueba fin',
                            border: OutlineInputBorder(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDate(fechaPruebaFin)),
                              const Icon(Icons.calendar_today, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: rtFaseAController,
                  decoration: const InputDecoration(
                    labelText: 'RT. FASE A',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: rtFaseBController,
                  decoration: const InputDecoration(
                    labelText: 'RT. FASE B',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: rtFaseCController,
                  decoration: const InputDecoration(
                    labelText: 'RT. FASE C',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: resistenciaAislamientoController,
                  decoration: const InputDecoration(
                    labelText: 'Resistencia de Aislamiento',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: rigidezDieletricaController,
                  decoration: const InputDecoration(
                    labelText: 'Rigidez Dieléctrica',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: estadoController,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context, fechaAlta, (d) => setState(() => fechaAlta = d)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de entrada',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(fechaAlta)),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context, fechaSalida, (d) => setState(() => fechaSalida = d)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de salida',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(fechaSalida)),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final pesoPlacaDeDatos = '${pesoPlacaDeDatosController.text.trim()} KGS';
                      final litros = '${litrosController.text.trim()} LTS';
                      final mantenimiento = Mantenimiento(
                        area: areaController.text,
                        capacidadKVA: double.tryParse(capacidadController.text) ?? 0,
                        economico: economicoController.text,
                        estado: estadoController.text,
                        fases: int.tryParse(fasesController.text) ?? 0,
                        fecha_de_alta: fechaAlta,
                        fecha_de_salida_del_taller: fechaSalida,
                        fecha_fabricacion: fechaFabricacion,
                        fecha_de_entrada_al_taller: fechaLlegada,
                        fecha_prueba: RangoFecha(inicio: fechaPruebaInicio, fin: fechaPruebaFin),
                        peso_placa_de_datos: pesoPlacaDeDatos,
                        aceite: litros,
                        marca: marcaController.text,
                        numero_mantenimiento: int.tryParse(numeroMantenimientoController.text) ?? 0,
                        resistencia_aislamiento_megaoms: int.tryParse(resistenciaAislamientoController.text) ?? 0,
                        rigidez_dielecrica_kv: rigidezDieletricaController.text,
                        rt_fase_a: double.tryParse(rtFaseAController.text),
                        rt_fase_b: double.tryParse(rtFaseBController.text),
                        rt_fase_c: double.tryParse(rtFaseCController.text),
                        serie: serieController.text,
                      );
                      await addMantenimiento(mantenimiento);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mantenimiento agregado correctamente')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Guardar', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}