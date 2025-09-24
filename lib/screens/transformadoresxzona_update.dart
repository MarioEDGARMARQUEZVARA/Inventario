import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';

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
  late TextEditingController capacidadController;
  late TextEditingController faseController;
  late TextEditingController numeroDeSerieController;
  late TextEditingController litrosController;
  late TextEditingController pesoKgController;
  late TextEditingController relacionController;
  late TextEditingController statusController;

  late DateTime fechaMovimiento;

  @override
  void initState() {
    super.initState();
    final t = widget.transformador;
    zonaController = TextEditingController(text: t.zona);
    numEconomicoController = TextEditingController(text: t.numEconomico.toString());
    marcaController = TextEditingController(text: t.marca);
    capacidadController = TextEditingController(text: t.capacidad.toString());
    faseController = TextEditingController(text: t.fase.toString());
    numeroDeSerieController = TextEditingController(text: t.numeroDeSerie);
    litrosController = TextEditingController(text: t.litros.replaceAll(' LTS', ''));
    pesoKgController = TextEditingController(text: t.pesoKg.replaceAll(' KGS', ''));
    relacionController = TextEditingController(text: t.relacion.toString());
    statusController = TextEditingController(text: t.status);
    fechaMovimiento = t.fechaMovimiento;
  }

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

    final transformador = TransformadoresXZona(
      id: widget.transformador.id,
      zona: zonaController.text,
      numEconomico: int.tryParse(numEconomicoController.text) ?? 0,
      marca: marcaController.text,
      capacidad: double.tryParse(capacidadController.text) ?? 0,
      fase: int.tryParse(faseController.text) ?? 0,
      numeroDeSerie: numeroDeSerieController.text,
      litros: litros,
      pesoKg: pesoKg,
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
      appBar: AppBar(title: const Text('Actualizar Transformador')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}