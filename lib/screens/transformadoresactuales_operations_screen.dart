import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';
import 'package:inventario_proyecto/screens/transformadoresactuales_update.dart';
import 'package:inventario_proyecto/services/transformadores_service.dart';
import 'package:inventario_proyecto/widgets/eliminar_dialog.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';
import 'package:inventario_proyecto/widgets/motivo_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/transformadores2025_provider.dart';
import '../providers/session_provider.dart';
import '../widgets/inactivity_detector.dart';

class TransformadoresActualesOperationsScreen extends StatefulWidget {
  final Tranformadoresactuales transformador;

  const TransformadoresActualesOperationsScreen({super.key, required this.transformador});

  @override
  State<TransformadoresActualesOperationsScreen> createState() => _TransformadoresActualesOperationsScreenState();
}

class _TransformadoresActualesOperationsScreenState extends State<TransformadoresActualesOperationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Transformadores2025Provider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: true);

    return InactivityDetector(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: sessionProvider.showTimeoutDialog 
              ? Colors.orange 
              : const Color(0xFF2A1AFF),
          title: const Text(
            'Transformadores 2025',
            style: TextStyle(color: Colors.white),
          ),
          leading: sessionProvider.showTimeoutDialog
              ? IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
          elevation: 0,
        ),
        drawer: const MainDrawer(),
        body: sessionProvider.showTimeoutDialog
            ? _buildTimeoutContent()
            : _buildNormalContent(context, provider),
      ),
    );
  }

  Widget _buildNormalContent(BuildContext context, Transformadores2025Provider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Consecutivo: ${widget.transformador.consecutivo}', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Fecha de llegada: ${_formatDate(widget.transformador.fecha_de_llegada)}'),
          Text('Área: ${widget.transformador.area}'),
          Text('Marca: ${widget.transformador.marca}'),
          Text('Capacidad KVA: ${widget.transformador.capacidadKVA}'),
          Text('Mes: ${widget.transformador.mes}'),
          Text('Área y fecha de entrega de transformador reparado: ${widget.transformador.area_fecha_de_entrega_transformador_reparado}'),
          Text('Económico: ${widget.transformador.economico}'),
          Text('Fases: ${widget.transformador.fases}'),
          Text('Serie: ${widget.transformador.serie}'),
          Text('Aceite: ${widget.transformador.aceite}'),
          Text('Peso en placa de datos: ${widget.transformador.peso_placa_de_datos}'),
          Text('Fecha de fabricación: ${_formatDate(widget.transformador.fecha_fabricacion)}'),
          Text('Fecha de prueba: ${_formatDate(widget.transformador.fecha_prueba)}'),
          Text('Valor de prueba 1: ${widget.transformador.valor_prueba_1}'),
          Text('Valor de prueba 2: ${widget.transformador.valor_prueba_2}'),
          Text('Valor de prueba 3: ${widget.transformador.valor_prueba_3}'),
          Text('Resistencia de Aislamiento de megaoms: ${widget.transformador.resistencia_aislamiento_megaoms}'),
          Text('Rigidez Dieléctrica: ${widget.transformador.rigidez_dielecrica_kv}'),
          Text('Estado: ${widget.transformador.estado}'),
          Text('Fecha de entrada: ${_formatDate(widget.transformador.fecha_de_entrada_al_taller)}'),
          Text('Fecha de salida: ${_formatDate(widget.transformador.fecha_de_salida_del_taller)}'),
          Text('Fecha de entrega: ${_formatDate(widget.transformador.fecha_entrega_almacen)}'),
          Text('Salida a mantenimiento mayor: ${widget.transformador.salida_mantenimiento ? "Sí" : "No"}'),
          Text('Fecha de salida a mantenimiento mayor: ${widget.transformador.fecha_salida_mantenimiento != null ? _formatDate(widget.transformador.fecha_salida_mantenimiento!) : "N/A"}'),
          Text('Baja: ${widget.transformador.baja ? "Sí" : "No"}'),
          Text('Cargas: ${widget.transformador.cargas}'),
          const SizedBox(height: 24),

          // Eliminar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final confirmar = await eliminarDialog(context);
                if (confirmar == true && widget.transformador.id != null) {
                  await provider.deleteTransformadorProvider(widget.transformador.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transformador eliminado')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),

          // Actualizar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2A1AFF)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TransformadoresActualesUpdateScreen(transformador: widget.transformador),
                  ),
                ).then((_) {
                  provider.refreshData();
                });
              },
              child: const Text('Actualizar', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),

          // Exportar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                await exportTransformadoresToExcel(context);
              },
              child: const Text('Exportar a xlsx', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),

          // Enviar a mantenimiento
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              onPressed: () async {
                if (widget.transformador.id == null) return;

                final motivo = await mostrarMotivoDialog(context);
                if (motivo != null && motivo.isNotEmpty) {
                  final result = await provider.enviarAMantenimientoProvider(widget.transformador.id!, motivo);
                  if (result == 200) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enviado a mantenimiento')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al enviar a mantenimiento')),
                    );
                  }
                }
              },
              child: const Text('Enviar a mantenimiento', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeoutContent() {
    return Container(
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
          const Text(
            'Abre el menú lateral para extender tu sesión',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildButtonList(),
        ],
      ),
    );
  }

  Widget _buildButtonList() {
    return Column(
      children: [
        _buildDisabledButton('Eliminar', Colors.red),
        const SizedBox(height: 12),
        _buildDisabledButton('Actualizar', Color(0xFF2A1AFF)),
        const SizedBox(height: 12),
        _buildDisabledButton('Exportar a xlsx', Colors.green),
        const SizedBox(height: 12),
        _buildDisabledButton('Enviar a mantenimiento', Colors.cyan),
      ],
    );
  }

  Widget _buildDisabledButton(String text, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.5),
        ),
        onPressed: null,
        child: Text(text, style: const TextStyle(color: Colors.white54)),
      ),
    );
  }
}