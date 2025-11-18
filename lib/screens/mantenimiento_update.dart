import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../widgets/inactivity_detector.dart';
import '../widgets/main_drawer.dart';

class MantenimientoUpdateScreen extends StatefulWidget {
  final Mantenimiento mantenimiento;
  const MantenimientoUpdateScreen({super.key, required this.mantenimiento});

  @override
  State<MantenimientoUpdateScreen> createState() => _MantenimientoUpdateScreenState();
}

class _MantenimientoUpdateScreenState extends State<MantenimientoUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  late DateTime fechaPrueba1;
  late DateTime fechaPrueba2;

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
    fechaAlta = m.fecha_de_alta ?? DateTime.now();
    fechaSalida = m.fecha_de_salida_del_taller ?? DateTime.now();
    fechaFabricacion = m.fecha_fabricacion ?? DateTime.now();
    fechaLlegada = m.fecha_de_entrada_al_taller ?? DateTime.now();
    fechaPrueba1 = m.fecha_prueba_1 ?? DateTime.now();
    fechaPrueba2 = m.fecha_prueba_2 ?? DateTime.now();
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

  Widget _buildNormalContent() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Actualizar Mantenimiento'),
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
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: fasesController,
                  decoration: const InputDecoration(
                    labelText: 'Fases',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: pesoPlacaDeDatosController,
                  decoration: const InputDecoration(
                    labelText: 'Kilos',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: rtFaseBController,
                  decoration: const InputDecoration(
                    labelText: 'RT. FASE B',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: rtFaseCController,
                  decoration: const InputDecoration(
                    labelText: 'RT. FASE C',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: resistenciaAislamientoController,
                  decoration: const InputDecoration(
                    labelText: 'Resistencia de Aislamiento',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: rigidezDieletricaController,
                  decoration: const InputDecoration(
                    labelText: 'Rigidez Dieléctrica',
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
                        fecha_prueba_1: fechaPrueba1,
                        fecha_prueba_2: fechaPrueba2,
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

  Widget _buildTimeoutContent() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Actualizar Mantenimiento'),
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
            _buildDisabledButton('Guardar Cambios', Colors.blue[700]!),
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