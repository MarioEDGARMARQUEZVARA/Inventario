import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';

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
  late TextEditingController kilosController;
  late TextEditingController litrosController;
  late TextEditingController marcaController;
  late TextEditingController numeroMantenimientoController;
  late TextEditingController resistenciaAislamientoController;
  late TextEditingController rigidezDieletricaController;
  late TextEditingController rtFaseAController;
  late TextEditingController rtFaseBController;
  late TextEditingController rtFaseCController;
  late TextEditingController serieController;

  late DateTime fechaAlta;
  late DateTime fechaSalida;
  late DateTime fechaFabricacion;
  late DateTime fechaLlegada;
  late DateTime fechaPruebaInicio;
  late DateTime fechaPruebaFin;

  @override
  void initState() {
    super.initState();
    final m = widget.mantenimiento;
    areaController = TextEditingController(text: m.area);
    capacidadController = TextEditingController(text: m.capacidad.toString());
    economicoController = TextEditingController(text: m.economico);
    estadoController = TextEditingController(text: m.estado);
    fasesController = TextEditingController(text: m.fases.toString());
    kilosController = TextEditingController(text: m.kilos.replaceAll(' KGS', ''));
    litrosController = TextEditingController(text: m.litros.replaceAll(' LTS', ''));
    marcaController = TextEditingController(text: m.marca);
    numeroMantenimientoController = TextEditingController(text: m.numero_mantenimiento.toString());
    resistenciaAislamientoController = TextEditingController(text: m.resistencia_aislamiento.toString());
    rigidezDieletricaController = TextEditingController(text: m.rigidez_dieletrica);
    rtFaseAController = TextEditingController(text: m.rt_fase_a?.toString() ?? '');
    rtFaseBController = TextEditingController(text: m.rt_fase_b?.toString() ?? '');
    rtFaseCController = TextEditingController(text: m.rt_fase_c?.toString() ?? '');
    serieController = TextEditingController(text: m.serie);

    fechaAlta = m.fecha_de_alta;
    fechaSalida = m.fecha_de_salida;
    fechaFabricacion = m.fecha_fabricacion;
    fechaLlegada = m.fecha_llegada;
    fechaPruebaInicio = m.fecha_prueba.inicio;
    fechaPruebaFin = m.fecha_prueba.fin;
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
      appBar: AppBar(title: const Text('Actualizar Mantenimiento')),
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
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: economicoController,
                decoration: const InputDecoration(labelText: 'Económico'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: fasesController,
                decoration: const InputDecoration(labelText: 'Fases'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: kilosController,
                decoration: const InputDecoration(labelText: 'Kilos'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: litrosController,
                decoration: const InputDecoration(labelText: 'Litros'),
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
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: resistenciaAislamientoController,
                decoration: const InputDecoration(labelText: 'Resistencia de aislamiento'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: rigidezDieletricaController,
                decoration: const InputDecoration(labelText: 'Rigidez dieléctrica'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: rtFaseAController,
                decoration: const InputDecoration(labelText: 'RT Fase A'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: rtFaseBController,
                decoration: const InputDecoration(labelText: 'RT Fase B'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: rtFaseCController,
                decoration: const InputDecoration(labelText: 'RT Fase C'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: serieController,
                decoration: const InputDecoration(labelText: 'Serie'),
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
                title: Text('Fecha de fabricación: ${fechaFabricacion.day}/${fechaFabricacion.month}/${fechaFabricacion.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaFabricacion, (d) => setState(() => fechaFabricacion = d)),
              ),
              ListTile(
                title: Text('Fecha de llegada: ${fechaLlegada.day}/${fechaLlegada.month}/${fechaLlegada.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaLlegada, (d) => setState(() => fechaLlegada = d)),
              ),
              ListTile(
                title: Text('Fecha de prueba inicio: ${fechaPruebaInicio.day}/${fechaPruebaInicio.month}/${fechaPruebaInicio.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaPruebaInicio, (d) => setState(() => fechaPruebaInicio = d)),
              ),
              ListTile(
                title: Text('Fecha de prueba fin: ${fechaPruebaFin.day}/${fechaPruebaFin.month}/${fechaPruebaFin.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaPruebaFin, (d) => setState(() => fechaPruebaFin = d)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final kilos = '${kilosController.text.trim()} KGS';
                    final litros = '${litrosController.text.trim()} LTS';
                    final mantenimiento = Mantenimiento(
                      id: widget.mantenimiento.id,
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
                    await updateMantenimiento(mantenimiento);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mantenimiento actualizado correctamente')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

