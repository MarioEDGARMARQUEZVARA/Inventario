import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';
import 'package:intl/intl.dart';

class TransformadoresxzonaAddScreen extends StatefulWidget {
  final String? zona;
  const TransformadoresxzonaAddScreen({super.key, this.zona});

  @override
  State<TransformadoresxzonaAddScreen> createState() => _TransformadoresxzonaAddScreenState();
}

class _TransformadoresxzonaAddScreenState extends State<TransformadoresxzonaAddScreen> {
  final _formKey = GlobalKey<FormState>();

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
      status: statusController.text,
      fechaMovimiento: fechaMovimiento,
      reparado: false,
    );
    await addTransformador(transformador);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transformador agregado correctamente')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Transformador'),
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
}