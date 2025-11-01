import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';
import 'package:intl/intl.dart';

class TransformadoresxzonaUpdateScreen extends StatefulWidget {
  final TransformadoresXZona transformador;
  const TransformadoresxzonaUpdateScreen({super.key, required this.transformador});

  @override
  State<TransformadoresxzonaUpdateScreen> createState() => _TransformadoresxzonaUpdateScreenState();
}

class _TransformadoresxzonaUpdateScreenState extends State<TransformadoresxzonaUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController zonaController;
  late TextEditingController numEconomicoController;
  late TextEditingController marcaController;
  late TextEditingController capacidadKVAController;
  late TextEditingController faseController;
  late TextEditingController serieController;
  late TextEditingController aceiteController;
  late TextEditingController peso_placa_de_datosController;
  late TextEditingController relacionController;
  late TextEditingController statusController;

  late DateTime fechaMovimiento;

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  void initState() {
    super.initState();
    final t = widget.transformador;
    zonaController = TextEditingController(text: t.zona);
    numEconomicoController = TextEditingController(text: t.economico.toString());
    marcaController = TextEditingController(text: t.marca);
    capacidadKVAController = TextEditingController(text: t.capacidadKVA.toString());
    faseController = TextEditingController(text: t.fases.toString());
    serieController = TextEditingController(text: t.serie);
    aceiteController = TextEditingController(text: t.aceite.replaceAll(' LTS', ''));
    peso_placa_de_datosController = TextEditingController(text: t.peso_placa_de_datos.replaceAll(' KGS', ''));
    relacionController = TextEditingController(text: t.relacion.toString());
    statusController = TextEditingController(text: t.status);
    fechaMovimiento = t.fechaMovimiento!;
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

    final transformador = TransformadoresXZona(
      id: widget.transformador.id,
      zona: zonaController.text,
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
      reparado: widget.transformador.reparado,
      motivo: widget.transformador.motivo,
    );
    await updateTransformador(transformador);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transformador actualizado correctamente')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Transformador'),
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
                  controller: zonaController,
                  decoration: const InputDecoration(
                    labelText: 'Zona',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),

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
                  child: const Text('Actualizar', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}