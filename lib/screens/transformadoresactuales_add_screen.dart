import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/services/transformadores_service.dart';

class TransformadoresActualesAddScreen extends StatefulWidget {
  const TransformadoresActualesAddScreen({super.key});

  @override
  State<TransformadoresActualesAddScreen> createState() => _TransformadoresActualesAddScreenState();
}

class _TransformadoresActualesAddScreenState extends State<TransformadoresActualesAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = TransformadoresService();

  final areaController = TextEditingController();
  DateTime fechaDeLlegada = DateTime.now();
  final mesController = TextEditingController();
  final marcaController = TextEditingController();
  final aceiteController = TextEditingController();
  final economicoController = TextEditingController();
  final capacidadKVAController = TextEditingController();
  final fasesController = TextEditingController();
  final serieController = TextEditingController();
  final pesoPlacaController = TextEditingController();
  DateTime fechaFabricacion = DateTime.now();
  DateTime fechaPrueba = DateTime.now();
  final valorPrueba1Controller = TextEditingController();
  final valorPrueba2Controller = TextEditingController();
  final valorPrueba3Controller = TextEditingController();
  final resistenciaAislamientoController = TextEditingController();
  final rigidezDielecricaController = TextEditingController();
  final estadoController = TextEditingController();
  DateTime fechaEntradaTaller = DateTime.now();
  DateTime fechaSalidaTaller = DateTime.now();
  DateTime fechaEntregaAlmacen = DateTime.now();
  final salidaMantenimientoController = TextEditingController();
  DateTime fechaSalidaMantenimiento = DateTime.now();
  final bajaController = TextEditingController();
  final cargasController = TextEditingController();
  final areaEntregaReparadoController = TextEditingController();

  final List<String> meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];
  String? mesSeleccionado;

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
    mesController.dispose();
    marcaController.dispose();
    aceiteController.dispose();
    economicoController.dispose();
    capacidadKVAController.dispose();
    fasesController.dispose();
    serieController.dispose();
    pesoPlacaController.dispose();
    valorPrueba1Controller.dispose();
    valorPrueba2Controller.dispose();
    valorPrueba3Controller.dispose();
    resistenciaAislamientoController.dispose();
    rigidezDielecricaController.dispose();
    estadoController.dispose();
    salidaMantenimientoController.dispose();
    bajaController.dispose();
    cargasController.dispose();
    areaEntregaReparadoController.dispose();
    super.dispose();
  }

  Future<int> _getConsecutivo() async {
    final snapshot = await FirebaseFirestore.instance.collection('transformadores2025').get();
    return snapshot.docs.length + 1;
  }

  Future<void> _guardarTransformador() async {
    final consecutivo = await _getConsecutivo();
    final aceite = '${aceiteController.text.trim()} LTS';
    final pesoPlaca = '${pesoPlacaController.text.trim()} KGS';

    final transformador = Tranformadoresactuales(
      area: areaController.text,
      consecutivo: consecutivo,
      fecha_de_llegada: fechaDeLlegada,
      mes: mesSeleccionado ?? '',
      marca: marcaController.text,
      aceite: aceite,
      economico: economicoController.text,
      capacidadKVA: double.tryParse(capacidadKVAController.text) ?? 0,
      fases: int.tryParse(fasesController.text) ?? 0,
      serie: serieController.text,
      peso_placa_de_datos: pesoPlaca,
      fecha_fabricacion: fechaFabricacion,
      fecha_prueba: fechaPrueba,
      valor_prueba_1: valorPrueba1Controller.text,
      valor_prueba_2: valorPrueba2Controller.text,
      valor_prueba_3: valorPrueba3Controller.text,
      resistencia_aislamiento_megaoms: int.tryParse(resistenciaAislamientoController.text) ?? 0,
      rigidez_dielecrica_kv: rigidezDielecricaController.text,
      estado: estadoController.text,
      fecha_de_entrada_al_taller: fechaEntradaTaller,
      fecha_de_salida_del_taller: fechaSalidaTaller,
      fecha_entrega_almacen: fechaEntregaAlmacen,
      salida_mantenimiento: salidaMantenimientoController.text,
      fecha_salida_mantenimiento: fechaSalidaMantenimiento,
      baja: bajaController.text,
      cargas: int.tryParse(cargasController.text) ?? 0,
      area_fecha_de_entrega_transformador_reparado: areaEntregaReparadoController.text,
    );

    await _service.agregarTransformadorActual(transformador);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Transformador Actual')),
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
              ListTile(
                title: Text('Fecha de llegada: ${fechaDeLlegada.day}/${fechaDeLlegada.month}/${fechaDeLlegada.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaDeLlegada, (d) => setState(() => fechaDeLlegada = d)),
              ),
              DropdownButtonFormField<String>(
                value: mesSeleccionado,
                decoration: const InputDecoration(labelText: 'Mes'),
                items: meses.map((mes) {
                  return DropdownMenuItem(
                    value: mes,
                    child: Text(mes),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    mesSeleccionado = value;
                  });
                },
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: aceiteController,
                decoration: const InputDecoration(labelText: 'Aceite'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: economicoController,
                decoration: const InputDecoration(labelText: 'Económico'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: capacidadKVAController,
                decoration: const InputDecoration(labelText: 'Capacidad KVA'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: fasesController,
                decoration: const InputDecoration(labelText: 'Fases'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: serieController,
                decoration: const InputDecoration(labelText: 'Serie'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: pesoPlacaController,
                decoration: const InputDecoration(labelText: 'Peso placa de datos'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              ListTile(
                title: Text('Fecha fabricación: ${fechaFabricacion.day}/${fechaFabricacion.month}/${fechaFabricacion.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaFabricacion, (d) => setState(() => fechaFabricacion = d)),
              ),
              ListTile(
                title: Text('Fecha prueba: ${fechaPrueba.day}/${fechaPrueba.month}/${fechaPrueba.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaPrueba, (d) => setState(() => fechaPrueba = d)),
              ),
              TextFormField(
                controller: valorPrueba1Controller,
                decoration: const InputDecoration(labelText: 'Valor prueba 1'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: valorPrueba2Controller,
                decoration: const InputDecoration(labelText: 'Valor prueba 2'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: valorPrueba3Controller,
                decoration: const InputDecoration(labelText: 'Valor prueba 3'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: resistenciaAislamientoController,
                decoration: const InputDecoration(labelText: 'Resistencia aislamiento megaoms'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: rigidezDielecricaController,
                decoration: const InputDecoration(labelText: 'Rigidez dieléctrica KV'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              ListTile(
                title: Text('Fecha entrada al taller: ${fechaEntradaTaller.day}/${fechaEntradaTaller.month}/${fechaEntradaTaller.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaEntradaTaller, (d) => setState(() => fechaEntradaTaller = d)),
              ),
              ListTile(
                title: Text('Fecha salida del taller: ${fechaSalidaTaller.day}/${fechaSalidaTaller.month}/${fechaSalidaTaller.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaSalidaTaller, (d) => setState(() => fechaSalidaTaller = d)),
              ),
              ListTile(
                title: Text('Fecha entrega almacén: ${fechaEntregaAlmacen.day}/${fechaEntregaAlmacen.month}/${fechaEntregaAlmacen.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaEntregaAlmacen, (d) => setState(() => fechaEntregaAlmacen = d)),
              ),
              TextFormField(
                controller: salidaMantenimientoController,
                decoration: const InputDecoration(labelText: 'Salida mantenimiento'),
              ),
              ListTile(
                title: Text('Fecha salida mantenimiento: ${fechaSalidaMantenimiento.day}/${fechaSalidaMantenimiento.month}/${fechaSalidaMantenimiento.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaSalidaMantenimiento, (d) => setState(() => fechaSalidaMantenimiento = d)),
              ),
              TextFormField(
                controller: bajaController,
                decoration: const InputDecoration(labelText: 'Baja'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: cargasController,
                decoration: const InputDecoration(labelText: 'Cargas'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: areaEntregaReparadoController,
                decoration: const InputDecoration(labelText: 'Área fecha de entrega transformador reparado'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await _guardarTransformador();
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