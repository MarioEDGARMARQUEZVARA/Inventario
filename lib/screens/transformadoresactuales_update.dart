import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';
import 'package:inventario_proyecto/services/transformadores_service.dart';

class TransformadoresActualesUpdateScreen extends StatefulWidget {
  final Tranformadoresactuales transformador;

  const TransformadoresActualesUpdateScreen({super.key, required this.transformador});

  @override
  State<TransformadoresActualesUpdateScreen> createState() => _TransformadoresActualesUpdateScreenState();
}

class _TransformadoresActualesUpdateScreenState extends State<TransformadoresActualesUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController areaController;
  late DateTime fechaDeLlegada;
  late String? mesSeleccionado;
  late TextEditingController marcaController;
  late TextEditingController aceiteController;
  late TextEditingController economicoController;
  late TextEditingController capacidadKVAController;
  late TextEditingController fasesController;
  late TextEditingController serieController;
  late TextEditingController pesoPlacaController;
  late DateTime fechaFabricacion;
  late DateTime fechaPrueba;
  late TextEditingController valorPrueba1Controller;
  late TextEditingController valorPrueba2Controller;
  late TextEditingController valorPrueba3Controller;
  late TextEditingController resistenciaAislamientoController;
  late TextEditingController rigidezDielecricaController;
  late TextEditingController estadoController;
  late DateTime fechaEntradaTaller;
  late DateTime fechaSalidaTaller;
  late DateTime fechaEntregaAlmacen;
  late TextEditingController salidaMantenimientoController;
  late bool salidaMantenimiento;
  DateTime? fechaSalidaMantenimiento;
  late TextEditingController motivoController;
  late TextEditingController bajaController;
  late TextEditingController areaEntregaReparadoController;
  late TextEditingController cargasController;

  final List<String> meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  @override
  void initState() {
    super.initState();
    final t = widget.transformador;
    areaController = TextEditingController(text: t.area);
    fechaDeLlegada = t.fecha_de_llegada;
    mesSeleccionado = t.mes;
    marcaController = TextEditingController(text: t.marca);
    aceiteController = TextEditingController(text: t.aceite.replaceAll(' LTS', ''));
    economicoController = TextEditingController(text: t.economico);
    capacidadKVAController = TextEditingController(text: t.capacidadKVA.toString());
    fasesController = TextEditingController(text: t.fases.toString());
    serieController = TextEditingController(text: t.serie);
    pesoPlacaController = TextEditingController(text: t.peso_placa_de_datos.replaceAll(' KGS', ''));
    fechaFabricacion = t.fecha_fabricacion;
    fechaPrueba = t.fecha_prueba;
    valorPrueba1Controller = TextEditingController(text: t.valor_prueba_1);
    valorPrueba2Controller = TextEditingController(text: t.valor_prueba_2);
    valorPrueba3Controller = TextEditingController(text: t.valor_prueba_3);
    resistenciaAislamientoController = TextEditingController(text: t.resistencia_aislamiento_megaoms.toString());
    rigidezDielecricaController = TextEditingController(text: t.rigidez_dielecrica_kv);
    estadoController = TextEditingController(text: t.estado);
    fechaEntradaTaller = t.fecha_de_entrada_al_taller;
    fechaSalidaTaller = t.fecha_de_salida_del_taller;
    fechaEntregaAlmacen = t.fecha_entrega_almacen;
    motivoController = TextEditingController(text: t.motivo ?? '');
    cargasController = TextEditingController(text: t.cargas.toString());
    motivoController = TextEditingController(text: t.motivo ?? '');
    areaEntregaReparadoController = TextEditingController(text: t.area_fecha_de_entrega_transformador_reparado ?? '');
    motivoController = TextEditingController(text: t.motivo ?? '');
    bajaController = TextEditingController(text: t.baja ?? '');
    motivoController = TextEditingController(text: t.motivo ?? '');
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
    motivoController.dispose();
    super.dispose();
  }

  Future<void> _actualizarTransformador() async {
    final t = widget.transformador;
    t.area = areaController.text;
    t.fecha_de_llegada = fechaDeLlegada;
    t.mes = mesSeleccionado ?? '';
    t.marca = marcaController.text;
    t.aceite = '${aceiteController.text.trim()} LTS';
    t.economico = economicoController.text;
    t.capacidadKVA = double.tryParse(capacidadKVAController.text) ?? 0;
    t.fases = int.tryParse(fasesController.text) ?? 0;
    t.serie = serieController.text;
    t.peso_placa_de_datos = '${pesoPlacaController.text.trim()} KGS';
    t.fecha_fabricacion = fechaFabricacion;
    t.fecha_prueba = fechaPrueba;
    t.valor_prueba_1 = valorPrueba1Controller.text;
    t.valor_prueba_2 = valorPrueba2Controller.text;
    t.valor_prueba_3 = valorPrueba3Controller.text;
    t.resistencia_aislamiento_megaoms = int.tryParse(resistenciaAislamientoController.text) ?? 0;
    t.rigidez_dielecrica_kv = rigidezDielecricaController.text;
    t.estado = estadoController.text;
    t.fecha_de_entrada_al_taller = fechaEntradaTaller;
    t.fecha_de_salida_del_taller = fechaSalidaTaller;
    t.fecha_entrega_almacen = fechaEntregaAlmacen;
    t.salida_mantenimiento = salidaMantenimiento;
    t.fecha_salida_mantenimiento = salidaMantenimiento ? fechaSalidaMantenimiento : null;
    t.motivo = salidaMantenimiento ? motivoController.text : null;
    t.baja = bajaController.text;
    t.cargas = int.tryParse(cargasController.text) ?? 0;
    t.area_fecha_de_entrega_transformador_reparado = areaEntregaReparadoController.text;

    await updateTransformador(t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Transformador Actual')),
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
                items: meses.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (v) => setState(() => mesSeleccionado = v),
                decoration: const InputDecoration(labelText: 'Mes'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: aceiteController,
                decoration: const InputDecoration(labelText: 'Aceite (LTS)'),
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
                decoration: const InputDecoration(labelText: 'Peso placa de datos (KGS)'),
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
              ),
              TextFormField(
                controller: valorPrueba2Controller,
                decoration: const InputDecoration(labelText: 'Valor prueba 2'),
              ),
              TextFormField(
                controller: valorPrueba3Controller,
                decoration: const InputDecoration(labelText: 'Valor prueba 3'),
              ),
              TextFormField(
                controller: resistenciaAislamientoController,
                decoration: const InputDecoration(labelText: 'Resistencia aislamiento (megaoms)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: rigidezDielecricaController,
                decoration: const InputDecoration(labelText: 'Rigidez dieléctrica (kv)'),
              ),
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              ListTile(
                title: Text('Fecha entrada taller: ${fechaEntradaTaller.day}/${fechaEntradaTaller.month}/${fechaEntradaTaller.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaEntradaTaller, (d) => setState(() => fechaEntradaTaller = d)),
              ),
              ListTile(
                title: Text('Fecha salida taller: ${fechaSalidaTaller.day}/${fechaSalidaTaller.month}/${fechaSalidaTaller.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaSalidaTaller, (d) => setState(() => fechaSalidaTaller = d)),
              ),
              ListTile(
                title: Text('Fecha entrega almacén: ${fechaEntregaAlmacen.day}/${fechaEntregaAlmacen.month}/${fechaEntregaAlmacen.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, fechaEntregaAlmacen, (d) => setState(() => fechaEntregaAlmacen = d)),
              ),
              DropdownButtonFormField<bool>(
                value: salidaMantenimiento,
                decoration: const InputDecoration(labelText: 'Salida mantenimiento'),
                items: const [
                  DropdownMenuItem(value: false, child: Text('No')),
                  DropdownMenuItem(value: true, child: Text('Sí')),
                ],
                onChanged: (value) {
                  setState(() {
                    salidaMantenimiento = value ?? false;
                    if (!salidaMantenimiento) {
                      fechaSalidaMantenimiento = null;
                      motivoController.clear();
                    }
                  });
                },
                validator: (v) => v == null ? 'Campo requerido' : null,
              ),
              if (salidaMantenimiento) ...[
                ListTile(
                  title: Text(
                    fechaSalidaMantenimiento == null
                        ? 'Selecciona fecha salida mantenimiento'
                        : 'Fecha salida mantenimiento: ${fechaSalidaMantenimiento!.day}/${fechaSalidaMantenimiento!.month}/${fechaSalidaMantenimiento!.year}'
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, fechaSalidaMantenimiento ?? DateTime.now(), (d) => setState(() => fechaSalidaMantenimiento = d)),
                ),
                TextFormField(
                  controller: motivoController,
                  decoration: const InputDecoration(labelText: 'Motivo'),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
              ],
              TextFormField(
                controller: bajaController,
                decoration: const InputDecoration(labelText: 'Baja'),
              ),
              TextFormField(
                controller: cargasController,
                decoration: const InputDecoration(labelText: 'Cargas'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: areaEntregaReparadoController,
                decoration: const InputDecoration(labelText: 'Área fecha entrega transformador reparado'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await _actualizarTransformador();
                    Navigator.pop(context); // Regresa y refresca la lista
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transformador actualizado')),
                    );
                  }
                },
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
