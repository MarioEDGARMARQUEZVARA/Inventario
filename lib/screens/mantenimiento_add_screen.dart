import 'package:flutter/material.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';

class MantenimientoAddScreen extends StatefulWidget {
  const MantenimientoAddScreen({super.key});

  @override
  State<MantenimientoAddScreen> createState() => _MantenimientoAddScreenState();
}

class _MantenimientoAddScreenState extends State<MantenimientoAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = MantenimientoService();

  final areaController = TextEditingController();
  final capacidadController = TextEditingController();
  final economicoController = TextEditingController();
  final estadoController = TextEditingController();
  final fasesController = TextEditingController();
  final kilosController = TextEditingController();
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
    kilosController.dispose();
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
      appBar: AppBar(title: const Text('Agregar Mantenimiento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: areaController,
                decoration: const InputDecoration(labelText: 'Área'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: capacidadController,
                decoration: const InputDecoration(labelText: 'Capacidad'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: economicoController,
                decoration: const InputDecoration(labelText: 'Económico'),
                 validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(labelText: 'Estado del transformador'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: fasesController,
                decoration: const InputDecoration(labelText: 'Fases'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              ListTile(
                title: Text('Fecha de alta: ${fechaAlta.day}/${fechaAlta.month}/${fechaAlta.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaAlta, (d) => setState(() => fechaAlta = d)),
              ),
              ListTile(
                title: Text('Fecha de salida: ${fechaSalida.day}/${fechaSalida.month}/${fechaSalida.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaSalida, (d) => setState(() => fechaSalida = d)),
              ),
              ListTile(
                title: Text('Fecha fabricación: ${fechaFabricacion.day}/${fechaFabricacion.month}/${fechaFabricacion.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaFabricacion, (d) => setState(() => fechaFabricacion = d)),
              ),
              ListTile(
                title: Text('Fecha llegada: ${fechaLlegada.day}/${fechaLlegada.month}/${fechaLlegada.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaLlegada, (d) => setState(() => fechaLlegada = d)),
              ),
              ListTile(
                title: Text('Fecha prueba inicio: ${fechaPruebaInicio.day}/${fechaPruebaInicio.month}/${fechaPruebaInicio.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaPruebaInicio, (d) => setState(() => fechaPruebaInicio = d)),
              ),
              ListTile(
                title: Text('Fecha prueba fin: ${fechaPruebaFin.day}/${fechaPruebaFin.month}/${fechaPruebaFin.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaPruebaFin, (d) => setState(() => fechaPruebaFin = d)),
              ),
              TextFormField(
                controller: kilosController,
                decoration: const InputDecoration(labelText: 'Kilos'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: litrosController,
                decoration: const InputDecoration(labelText: 'Litros'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: numeroMantenimientoController,
                decoration: const InputDecoration(labelText: 'Número de mantenimiento'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: resistenciaAislamientoController,
                decoration: const InputDecoration(labelText: 'Resistencia aislamiento'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: rigidezDieletricaController,
                decoration: const InputDecoration(labelText: 'Rigidez dieléctrica'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: rtFaseAController,
                decoration: const InputDecoration(labelText: 'RT Fase A'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: rtFaseBController,
                decoration: const InputDecoration(labelText: 'RT Fase B'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: rtFaseCController,
                decoration: const InputDecoration(labelText: 'RT Fase C'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: serieController,
                decoration: const InputDecoration(labelText: 'Serie'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final kilos = '${kilosController.text.trim()} KGS';
                    final litros = '${litrosController.text.trim()} LTS';
                    final mantenimiento = Mantenimiento(
                      area: areaController.text,
                      capacidad: double.tryParse(capacidadController.text) ?? 0,
                      economico: economicoController.text,
                      estado: estadoController.text,
                      fases: int.tryParse(fasesController.text) ?? 0,
                      fecha_de_alta: fechaAlta,
                      fecha_de_salida: fechaSalida,
                      fecha_fabricacion: fechaFabricacion,
                      fecha_llegada: fechaLlegada,
                      fecha_prueba: RangoFecha(inicio: fechaPruebaInicio, fin: fechaPruebaFin),
                      kilos: kilos,
                      litros: litros,
                      marca: marcaController.text,
                      numero_mantenimiento: int.tryParse(numeroMantenimientoController.text) ?? 0,
                      resistencia_aislamiento: int.tryParse(resistenciaAislamientoController.text) ?? 0,
                      rigidez_dieletrica: rigidezDieletricaController.text,
                      rt_fase_a: double.tryParse(rtFaseAController.text),
                      rt_fase_b: double.tryParse(rtFaseBController.text),
                      rt_fase_c: double.tryParse(rtFaseCController.text),
                      serie: serieController.text,
                    );
                    await _service.addMantenimiento(mantenimiento);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}