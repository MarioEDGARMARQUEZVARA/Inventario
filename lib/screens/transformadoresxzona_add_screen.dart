import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';

class TransformadoresxzonaAddScreen extends StatefulWidget {
  final String? zona;
  const TransformadoresxzonaAddScreen({super.key, this.zona});

  @override
  State<TransformadoresxzonaAddScreen> createState() => _TransformadoresxzonaAddScreenState();
}

class _TransformadoresxzonaAddScreenState extends State<TransformadoresxzonaAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = TransformadoresxzonaService();

  final numEconomicoController = TextEditingController();
  final marcaController = TextEditingController();
  final capacidadController = TextEditingController();
  final faseController = TextEditingController();
  final numeroDeSerieController = TextEditingController();
  final litrosController = TextEditingController();
  final pesoKgController = TextEditingController();
  final relacionController = TextEditingController();
  final statusController = TextEditingController();
  final zonaController = TextEditingController();

  DateTime fechaMovimiento = DateTime.now();

  @override
  void dispose() {
    zonaController.dispose();
    numEconomicoController.dispose();
    marcaController.dispose();
    capacidadController.dispose();
    faseController.dispose();
    numeroDeSerieController.dispose();
    litrosController.dispose();
    pesoKgController.dispose();
    relacionController.dispose();
    statusController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final litros = '${litrosController.text.trim()} LTS';
    final pesoKg = '${pesoKgController.text.trim()} KGS';

    final zonaFinal = widget.zona ?? zonaController.text.trim();

    final transformador = TransformadoresXZona(
      zona: zonaFinal,
      numEconomico: int.tryParse(numEconomicoController.text) ?? 0,
      marca: marcaController.text,
      capacidad: double.tryParse(capacidadController.text) ?? 0,
      fase: int.tryParse(faseController.text) ?? 0,
      numeroDeSerie: numeroDeSerieController.text,
      litros: litros,
      pesoKg: pesoKg,
      relacion: int.tryParse(relacionController.text) ?? 0,
      status: statusController.text,
      fechaMovimiento: fechaMovimiento, // <-- usa la fecha seleccionada
      reparado: false,
    );
    await _service.agregarTransformadorXZona(transformador);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Transformador')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (widget.zona == null)
                TextFormField(
                  controller: zonaController,
                  decoration: const InputDecoration(labelText: 'Zona'),
                  validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
              TextFormField(
                controller: numEconomicoController,
                decoration: const InputDecoration(labelText: 'Número económico'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: capacidadController,
                decoration: const InputDecoration(labelText: 'Capacidad'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: faseController,
                decoration: const InputDecoration(labelText: 'Fase'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: numeroDeSerieController,
                decoration: const InputDecoration(labelText: 'Número de serie'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: litrosController,
                decoration: const InputDecoration(labelText: 'Litros'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: pesoKgController,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: relacionController,
                decoration: const InputDecoration(labelText: 'Relación'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
              ListTile(
                title: Text('Fecha de movimiento: ${fechaMovimiento.day}/${fechaMovimiento.month}/${fechaMovimiento.year}'),
                trailing: const Icon(Icons.calendar_today),
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
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await _guardar();
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

