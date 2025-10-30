import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';
import 'package:intl/intl.dart';

class MantenimientoUpdateScreen extends StatefulWidget {
  final Mantenimiento mantenimiento;
  const MantenimientoUpdateScreen({super.key, required this.mantenimiento});

  @override
  State<MantenimientoUpdateScreen> createState() => _MantenimientoUpdateScreenState();
}

class _MantenimientoUpdateScreenState extends State<MantenimientoUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController areaController;
  late TextEditingController capacidadController;
  late TextEditingController economicoController;
  late TextEditingController estadoController;
  late TextEditingController fasesController;
  late TextEditingController pesoPlacaDeDatosController;
  late TextEditingController litrosController;
  late TextEditingController marcaController;
  late TextEditingController numeroMantenimientoController;
  late TextEditingController resistenciaAislamientoController;
  late TextEditingController rigidezDieletricaController;
  late TextEditingController rtFaseAController;
  late TextEditingController rtFaseBController;
  late TextEditingController rtFaseCController;
  late TextEditingController serieController;
  late TextEditingController motivoController;

  late DateTime fechaLlegada;
  late DateTime fechaAlta;
  late DateTime fechaSalida;
  late DateTime fechaFabricacion;
  late DateTime fechaPruebaInicio;
  late DateTime fechaPruebaFin;

  @override
  void initState() {
    super.initState();
    final m = widget.mantenimiento;
    areaController = TextEditingController(text: m.area);
    capacidadController = TextEditingController(text: m.capacidadKVA.toString());
    economicoController = TextEditingController(text: m.economico);
    estadoController = TextEditingController(text: m.estado);
    fasesController = TextEditingController(text: m.fases.toString());
    pesoPlacaDeDatosController = TextEditingController(text: m.peso_placa_de_datos.replaceAll(' KGS', ''));
    litrosController = TextEditingController(text: m.aceite.replaceAll(' LTS', ''));
    marcaController = TextEditingController(text: m.marca);
    numeroMantenimientoController = TextEditingController(text: m.numero_mantenimiento.toString());
    resistenciaAislamientoController = TextEditingController(text: m.resistencia_aislamiento_megaoms.toString());
    rigidezDieletricaController = TextEditingController(text: m.rigidez_dielecrica_kv);
    rtFaseAController = TextEditingController(text: m.rt_fase_a?.toString() ?? '');
    rtFaseBController = TextEditingController(text: m.rt_fase_b?.toString() ?? '');
    rtFaseCController = TextEditingController(text: m.rt_fase_c?.toString() ?? '');
    serieController = TextEditingController(text: m.serie);
    motivoController = TextEditingController(text: m.motivo ?? '');

    fechaAlta = m.fecha_de_alta!;
    fechaSalida = m.fecha_de_salida_del_taller!;
    fechaFabricacion = m.fecha_fabricacion!;
    fechaLlegada = m.fecha_de_entrada_al_taller!;
    fechaPruebaInicio = m.fecha_prueba.inicio!;
    fechaPruebaFin = m.fecha_prueba.fin!;
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

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
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
    motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Mantenimiento'),
        backgroundColor: Colors.blue[700],
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
                const SizedBox(height: 16),

                TextFormField(
                  controller: motivoController,
                  decoration: const InputDecoration(
                    labelText: 'Motivo',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final kilos = '${pesoPlacaDeDatosController.text.trim()} KGS';
                      final litros = '${litrosController.text.trim()} LTS';
                      final mantenimiento = Mantenimiento(
                        id: widget.mantenimiento.id,
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
                        peso_placa_de_datos: kilos,
                        aceite: litros,
                        marca: marcaController.text,
                        numero_mantenimiento: int.tryParse(numeroMantenimientoController.text) ?? 0,
                        resistencia_aislamiento_megaoms: int.tryParse(resistenciaAislamientoController.text) ?? 0,
                        rigidez_dielecrica_kv: rigidezDieletricaController.text,
                        rt_fase_a: double.tryParse(rtFaseAController.text),
                        rt_fase_b: double.tryParse(rtFaseBController.text),
                        rt_fase_c: double.tryParse(rtFaseCController.text),
                        serie: serieController.text,
                        motivo: motivoController.text.isNotEmpty ? motivoController.text : null,
                      );
                      await updateMantenimiento(mantenimiento);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mantenimiento actualizado correctamente')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Guardar cambios', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}