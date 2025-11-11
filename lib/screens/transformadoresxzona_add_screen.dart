import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../widgets/inactivity_detector.dart';
import '../widgets/main_drawer.dart';

class TransformadoresxzonaAddScreen extends StatefulWidget {
  final String? zona;
  const TransformadoresxzonaAddScreen({super.key, this.zona});

  @override
  State<TransformadoresxzonaAddScreen> createState() => _TransformadoresxzonaAddScreenState();
}

class _TransformadoresxzonaAddScreenState extends State<TransformadoresxzonaAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final numEconomicoController = TextEditingController();
  final marcaController = TextEditingController();
  final capacidadKVAController = TextEditingController();
  final faseController = TextEditingController();
  final serieController = TextEditingController();
  final aceiteController = TextEditingController();
  final peso_placa_de_datosController = TextEditingController();
  final relacionController = TextEditingController();
  final statusController = TextEditingController();
  final zonaController = TextEditingController();

  DateTime fechaMovimiento = DateTime.now();

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  void dispose() {
    zonaController.dispose();
    numEconomicoController.dispose();
    marcaController.dispose();
    capacidadKVAController.dispose();
    faseController.dispose();
    serieController.dispose();
    aceiteController.dispose();
    peso_placa_de_datosController.dispose();
    relacionController.dispose();
    statusController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final aceite = '${aceiteController.text.trim()} LTS';
    final peso_placa_de_datos = '${peso_placa_de_datosController.text.trim()} KGS';
    final zonaFinal = widget.zona ?? zonaController.text.trim();

    final transformador = TransformadoresXZona(
      zona: zonaFinal,
      economico: int.tryParse(numEconomicoController.text) ?? 0,
      marca: marcaController.text,
      capacidadKVA: double.tryParse(capacidadKVAController.text) ?? 0,
      fases: int.tryParse(faseController.text) ?? 0,
      serie: serieController.text,
      aceite: aceite,
      peso_placa_de_datos: peso_placa_de_datos,
      relacion: int.tryParse(relacionController.text) ?? 0,
      estado: statusController.text,
      fechaMovimiento: fechaMovimiento,
      reparado: false,
    );
    await addTransformador(transformador);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transformador agregado correctamente')),
    );
    Navigator.pop(context);
  }

  Widget _buildNormalContent() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Agregar Transformador'),
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
                if (widget.zona == null) ...[
                  TextFormField(
                    controller: zonaController,
                    decoration: const InputDecoration(
                      labelText: 'Zona',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: numEconomicoController,
                  decoration: const InputDecoration(
                    labelText: 'Número económico',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
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
                  controller: faseController,
                  decoration: const InputDecoration(
                    labelText: 'Fase',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: serieController,
                  decoration: const InputDecoration(
                    labelText: 'Número de serie',
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
                  controller: peso_placa_de_datosController,
                  decoration: const InputDecoration(
                    labelText: 'Peso (KGS)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: relacionController,
                  decoration: const InputDecoration(
                    labelText: 'Relación',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: statusController,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: fechaMovimiento,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        fechaMovimiento = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de movimiento',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDate(fechaMovimiento)),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      await _guardar();
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
        title: const Text('Agregar Transformador'),
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
            _buildDisabledButton('Guardar Transformador', Colors.blue[700]!),
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