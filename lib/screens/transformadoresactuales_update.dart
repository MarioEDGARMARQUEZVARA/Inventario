import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

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
    salidaMantenimiento = t.salida_mantenimiento;
    fechaSalidaMantenimiento = t.fecha_salida_mantenimiento;
    motivoController = TextEditingController(text: t.motivo ?? '');
    cargasController = TextEditingController(text: t.cargas.toString());
    bajaController = TextEditingController(text: t.baja ?? '');
    areaEntregaReparadoController = TextEditingController(text: t.area_fecha_de_entrega_transformador_reparado ?? '');
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
      appBar: AppBar(
        title: const Text('Editar Transformador Actual'),
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
                  controller: areaController,
                  decoration: const InputDecoration(
                    labelText: 'Área',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: () => _selectDate(context, fechaDeLlegada, (d) => setState(() => fechaDeLlegada = d)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de llegada',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(fechaDeLlegada)),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: mesSeleccionado,
                  items: meses.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (v) => setState(() => mesSeleccionado = v),
                  decoration: const InputDecoration(
                    labelText: 'Mes',
                    border: OutlineInputBorder(),
                  ),
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
                  controller: aceiteController,
                  decoration: const InputDecoration(
                    labelText: 'Aceite (LTS)',
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
                  controller: capacidadKVAController,
                  decoration: const InputDecoration(
                    labelText: 'Capacidad KVA',
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
                  controller: pesoPlacaController,
                  decoration: const InputDecoration(
                    labelText: 'Peso placa de datos (KGS)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: () => _selectDate(context, fechaFabricacion, (d) => setState(() => fechaFabricacion = d)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha fabricación',
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

                InkWell(
                  onTap: () => _selectDate(context, fechaPrueba, (d) => setState(() => fechaPrueba = d)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha prueba',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(fechaPrueba)),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: valorPrueba1Controller,
                  decoration: const InputDecoration(
                    labelText: 'Valor prueba 1',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: valorPrueba2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Valor prueba 2',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: valorPrueba3Controller,
                  decoration: const InputDecoration(
                    labelText: 'Valor prueba 3',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: resistenciaAislamientoController,
                  decoration: const InputDecoration(
                    labelText: 'Resistencia aislamiento (megaoms)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: rigidezDielecricaController,
                  decoration: const InputDecoration(
                    labelText: 'Rigidez dieléctrica (kv)',
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
                  onTap: () => _selectDate(context, fechaEntradaTaller, (d) => setState(() => fechaEntradaTaller = d)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha entrada taller',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(fechaEntradaTaller)),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: () => _selectDate(context, fechaSalidaTaller, (d) => setState(() => fechaSalidaTaller = d)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha salida taller',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(fechaSalidaTaller)),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: () => _selectDate(context, fechaEntregaAlmacen, (d) => setState(() => fechaEntregaAlmacen = d)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha entrega almacén',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(fechaEntregaAlmacen)),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                CheckboxListTile(
                  title: const Text('Salida mantenimiento'),
                  value: salidaMantenimiento,
                  onChanged: (v) => setState(() => salidaMantenimiento = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 16),

                if (salidaMantenimiento) ...[
                  InkWell(
                    onTap: () => _selectDate(
                      context,
                      fechaSalidaMantenimiento ?? DateTime.now(),
                      (d) => setState(() => fechaSalidaMantenimiento = d),
                    ),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Fecha salida mantenimiento',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDate(fechaSalidaMantenimiento ?? DateTime.now())),
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
                    validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                ],

                TextFormField(
                  controller: bajaController,
                  decoration: const InputDecoration(
                    labelText: 'Baja',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: cargasController,
                  decoration: const InputDecoration(
                    labelText: 'Cargas',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: areaEntregaReparadoController,
                  decoration: const InputDecoration(
                    labelText: 'Área fecha entrega transformador reparado',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      await _actualizarTransformador();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transformador actualizado correctamente')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
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