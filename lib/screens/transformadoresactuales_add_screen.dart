import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/services/transformadores_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../widgets/inactivity_detector.dart';
import '../widgets/main_drawer.dart';

class TransformadoresActualesAddScreen extends StatefulWidget {
  const TransformadoresActualesAddScreen({super.key});

  @override
  State<TransformadoresActualesAddScreen> createState() => _TransformadoresActualesAddScreenState();
}

class _TransformadoresActualesAddScreenState extends State<TransformadoresActualesAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final areaController = TextEditingController();
  DateTime fechaDeLlegada = DateTime.now();
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
  bool salidaMantenimiento = false;
  DateTime? fechaSalidaMantenimiento;
  final motivoController = TextEditingController();
  // CAMBIO: Cambiar TextEditingController por String? para el dropdown de baja
  String? bajaSeleccionada;
  final cargasController = TextEditingController();
  final areaEntregaReparadoController = TextEditingController();

  final List<String> meses = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];
  String? mesSeleccionado;

  // CAMBIO: Lista de opciones para baja
  final List<String> opcionesBaja = ['Sí', 'No'];

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
    cargasController.dispose();
    areaEntregaReparadoController.dispose();
    super.dispose();
  }

  Future<int> _getConsecutivo() async {
    final snapshot = await FirebaseFirestore.instance.collection('transformadores2025').get();
    return snapshot.docs.length + 1;
  }

// Reemplaza el método _guardarTransformador() completo:
Future<void> _guardarTransformador() async {
  final consecutivo = await _getConsecutivo();
  final aceite = '${aceiteController.text.trim()} LTS';
  final pesoPlaca = '${pesoPlacaController.text.trim()} KGS';
  final baja = bajaSeleccionada == 'Sí';

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
    salida_mantenimiento: salidaMantenimiento,
    fecha_salida_mantenimiento: salidaMantenimiento ? fechaSalidaMantenimiento : null,
    baja: baja,
    cargas: int.tryParse(cargasController.text) ?? 0,
    area_fecha_de_entrega_transformador_reparado: areaEntregaReparadoController.text,
    motivo: salidaMantenimiento ? motivoController.text : null,
    contadorEnviosMantenimiento: 0, // INICIALIZAR CONTADOR EN 0
  );

  await addTransformador(transformador);
  
  // Mostrar mensaje de éxito
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Transformador agregado correctamente')),
  );
  
  // Regresar a la pantalla anterior
  Navigator.pop(context);
}

  Widget _buildNormalContent() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Agregar Transformador Actual'),
        backgroundColor: const Color(0xFF2A1AFF),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
                  decoration: const InputDecoration(
                    labelText: 'Mes',
                    border: OutlineInputBorder(),
                  ),
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
                  keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: fasesController,
                  decoration: const InputDecoration(
                    labelText: 'Fases',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.number,
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
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: valorPrueba2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Valor prueba 2',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: valorPrueba3Controller,
                  decoration: const InputDecoration(
                    labelText: 'Valor prueba 3',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: resistenciaAislamientoController,
                  decoration: const InputDecoration(
                    labelText: 'Resistencia aislamiento (megaoms)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: rigidezDielecricaController,
                  decoration: const InputDecoration(
                    labelText: 'Rigidez dieléctrica (kv)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  keyboardType: TextInputType.number,
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
                // CAMBIO: Reemplazar TextFormField por DropdownButtonFormField para baja
                DropdownButtonFormField<String>(
                  value: bajaSeleccionada,
                  decoration: const InputDecoration(
                    labelText: 'Baja',
                    border: OutlineInputBorder(),
                  ),
                  items: opcionesBaja.map((opcion) {
                    return DropdownMenuItem(
                      value: opcion,
                      child: Text(opcion),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      bajaSeleccionada = value;
                    });
                  },
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: cargasController,
                  decoration: const InputDecoration(
                    labelText: 'Cargas',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: areaEntregaReparadoController,
                  decoration: const InputDecoration(
                    labelText: 'Área y fecha entrega transformador reparado',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      await _guardarTransformador();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transformador agregado correctamente')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
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

  Widget _buildTimeoutContent() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Agregar Transformador Actual'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: const MainDrawer(),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.timer,
              size: 80,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Sesión por expirar!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Consumer<SessionProvider>(
              builder: (context, sessionProvider, child) {
                return Text(
                  'Tiempo restante: ${sessionProvider.countdownSeconds} segundos',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Abre el menú lateral para extender tu sesión',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildDisabledButton('Guardar Transformador', Color(0xFF2196F3)),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledButton(String text, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: null,
        child: Text(text, style: const TextStyle(color: Colors.white54, fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, sessionProvider, child) {
        // Cerrar teclado cuando entra en modo timeout
        if (sessionProvider.showTimeoutDialog) {
          FocusScope.of(context).unfocus();
        }

        return InactivityDetector(
          child: sessionProvider.showTimeoutDialog 
              ? _buildTimeoutContent()
              : _buildNormalContent(),
        );
      },
    );
  }
}