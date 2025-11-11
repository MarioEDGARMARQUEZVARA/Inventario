import 'package:flutter/material.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../widgets/inactivity_detector.dart';
import '../widgets/main_drawer.dart';

class MantenimientoAddScreen extends StatefulWidget {
  const MantenimientoAddScreen({super.key});

  @override
  State<MantenimientoAddScreen> createState() => _MantenimientoAddScreenState();
}

class _MantenimientoAddScreenState extends State<MantenimientoAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  DateTime fechaPrueba1 = DateTime.now();
  DateTime fechaPrueba2 = DateTime.now();

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

  Widget _buildNormalContent() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Agregar Mantenimiento'),
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
                InkWell(
                  onTap: () => _selectDate(context, fechaPrueba1, (d) => setState(() => fechaPrueba1 = d)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de prueba 1',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(fechaPrueba1)),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context, fechaPrueba2, (d) => setState(() => fechaPrueba2 = d)),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de prueba 2',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(fechaPrueba2)),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: rtFaseAController,
                  decoration: const InputDecoration(
                    labelText: 'RT. FASE A',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: rtFaseBController,
                  decoration: const InputDecoration(
                    labelText: 'RT. FASE B',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: rtFaseCController,
                  decoration: const InputDecoration(
                    labelText: 'RT. FASE C',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: resistenciaAislamientoController,
                  decoration: const InputDecoration(
                    labelText: 'Resistencia de Aislamiento',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: rigidezDieletricaController,
                  decoration: const InputDecoration(
                    labelText: 'Rigidez Dieléctrica',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
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
                        fecha_prueba_1: fechaPrueba1,
                        fecha_prueba_2: fechaPrueba2,
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

  Widget _buildTimeoutContent() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Agregar Mantenimiento'),
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
            _buildDisabledButton('Guardar Mantenimiento', Colors.blue[700]!),
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