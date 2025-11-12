import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/motivo.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_update.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';
import 'package:inventario_proyecto/widgets/motivo_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/transformadoresxzona_provider.dart';
import 'package:inventario_proyecto/widgets/eliminar_dialog.dart';
import '../providers/session_provider.dart';
import '../widgets/inactivity_detector.dart';

class TrasnformadoresxzonaOperationsScreen extends StatefulWidget {
  final TransformadoresXZona transformador;

  const TrasnformadoresxzonaOperationsScreen({super.key, required this.transformador});

  @override
  State<TrasnformadoresxzonaOperationsScreen> createState() => _TrasnformadoresxzonaOperationsScreenState();
}

class _TrasnformadoresxzonaOperationsScreenState extends State<TrasnformadoresxzonaOperationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  String? _formatDateNullable(DateTime? date) {
    if (date == null) return null;
    if (date.year == 1900) return null;
    return _formatDate(date);
  }

  Future<List<Motivo>> _fetchMotivos(String docId) async {
    if (docId.isEmpty) return [];
    try {
      final snap = await FirebaseFirestore.instance
          .collection('Transformadoresxzona')
          .doc(docId)
          .collection('motivos')
          .orderBy('fecha', descending: true)
          .get();
      return snap.docs.map((d) => Motivo.fromMap(d.data(), id: d.id)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final fechaMov = _formatDateNullable(widget.transformador.fechaMovimiento);
    final provider = Provider.of<TransformadoresxZonaProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: true);

    return InactivityDetector(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: sessionProvider.showTimeoutDialog 
              ? Colors.orange 
              : const Color(0xFF2A1AFF),
          title: const Text(
            'Transformadores en la zona',
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
            : _buildNormalContent(context, provider, fechaMov),
      ),
    );
  }

  Widget _buildNormalContent(BuildContext context, TransformadoresxZonaProvider provider, String? fechaMov) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.transformador.zona.isNotEmpty) Text('Zona: ${widget.transformador.zona}'),
          if (widget.transformador.economico != 0) Text('Económico: ${widget.transformador.economico}'),
          if (widget.transformador.marca.isNotEmpty) Text('Marca: ${widget.transformador.marca}'),
          if (widget.transformador.capacidadKVA != 0) Text('capacidadKVA: ${widget.transformador.capacidadKVA}'),
          if (widget.transformador.fases != 0) Text('Fase: ${widget.transformador.fases}'),
          if (widget.transformador.serie.isNotEmpty) Text('Número de serie: ${widget.transformador.serie}'),
          if (widget.transformador.aceite.isNotEmpty) Text('Litros de aceite: ${widget.transformador.aceite}'),
          if (widget.transformador.peso_placa_de_datos.isNotEmpty) Text('Peso en kg: ${widget.transformador.peso_placa_de_datos}'),
          if (widget.transformador.relacion != null && widget.transformador.relacion != 0) Text('Relación: ${widget.transformador.relacion}'),
          if (widget.transformador.estado.isNotEmpty) Text('Status: ${widget.transformador.estado}'),
          if (fechaMov != null) Text('Fecha de movimiento: $fechaMov'),
          Text('Reparado: ${widget.transformador.reparado ? "Sí" : "No"}'),
          const SizedBox(height: 12),

          // Motivos (subcolección)
          FutureBuilder<List<Motivo>>(
            future: widget.transformador.id != null ? _fetchMotivos(widget.transformador.id!) : Future.value([]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox.shrink();
              final motivos = snapshot.data ?? [];
              if (motivos.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Motivos:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...motivos.map((m) {
                    final fecha = m.fecha != null ? '${m.fecha!.day.toString().padLeft(2,'0')}/${m.fecha!.month.toString().padLeft(2,'0')}/${m.fecha!.year}' : 'N/A';
                    return Text('- ${m.descripcion} (${fecha})');
                  }).toList(),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),

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
                    builder: (_) => TransformadoresxzonaUpdateScreen(transformador: widget.transformador),
                  ),
                ).then((_) {
                  provider.refreshData(widget.transformador.id!);
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
              onPressed: () {
                exportTransformadoresxzonaToExcel(context);
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
          const SizedBox(height: 12),
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