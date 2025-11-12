import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart' as mantenimiento_model;
import 'package:inventario_proyecto/screens/mantenimiento_update.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_proyecto/widgets/eliminar_dialog.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';
import 'package:inventario_proyecto/widgets/motivos_list.dart';
import 'package:inventario_proyecto/models/motivo.dart';
import 'package:provider/provider.dart';
import '../providers/mantenimento_provider.dart';
import '../providers/session_provider.dart';
import '../widgets/inactivity_detector.dart';

class MantenimientoOperationsScreen extends StatefulWidget {
  final mantenimiento_model.Mantenimiento mantenimiento;
  const MantenimientoOperationsScreen({super.key, required this.mantenimiento});

  @override
  State<MantenimientoOperationsScreen> createState() => _MantenimientoOperationsScreenState();
}

class _MantenimientoOperationsScreenState extends State<MantenimientoOperationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // SOLO resetear timer, NO iniciar sesión
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sessionProvider = context.read<SessionProvider>();
      sessionProvider.resetTimer();
    });
  }

  String _formatFecha(DateTime? fecha) {
    if (fecha == null) return "N/A";
    return "${fecha.day.toString().padLeft(2, '0')}/"
        "${fecha.month.toString().padLeft(2, '0')}/"
        "${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MantenimientoProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: true);

    return InactivityDetector(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: sessionProvider.showTimeoutDialog 
              ? Colors.orange 
              : const Color(0xFF2A1AFF),
          title: const Text('Mantenimiento', style: TextStyle(color: Colors.white)),
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

  Widget _buildNormalContent(BuildContext context, MantenimientoProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campos principales
            if (widget.mantenimiento.numero_mantenimiento != 0)
              Text('Número mantenimiento: ${widget.mantenimiento.numero_mantenimiento}'),
            if (widget.mantenimiento.area.isNotEmpty)
              Text('Área: ${widget.mantenimiento.area}'),
            if (widget.mantenimiento.marca.isNotEmpty)
              Text('Marca: ${widget.mantenimiento.marca}'),
            if (widget.mantenimiento.fecha_de_entrada_al_taller != null)
              Text('Fecha de entrada al taller: ${_formatFecha(widget.mantenimiento.fecha_de_entrada_al_taller)}'),
            if (widget.mantenimiento.economico.isNotEmpty)
              Text('Económico: ${widget.mantenimiento.economico}'),
            if (widget.mantenimiento.capacidadKVA != 0)
              Text('Capacidad KVA: ${widget.mantenimiento.capacidadKVA}'),
            if (widget.mantenimiento.fases != 0)
              Text('Fases: ${widget.mantenimiento.fases}'),
            if (widget.mantenimiento.serie.isNotEmpty)
              Text('Serie: ${widget.mantenimiento.serie}'),
            if (widget.mantenimiento.aceite.isNotEmpty)
              Text('Litros de aceite: ${widget.mantenimiento.aceite}'),
            if (widget.mantenimiento.peso_placa_de_datos.isNotEmpty)
              Text('Peso placa de datos: ${widget.mantenimiento.peso_placa_de_datos}'),
            if (widget.mantenimiento.fecha_fabricacion != null)
              Text('Fecha de fabricación: ${_formatFecha(widget.mantenimiento.fecha_fabricacion)}'),

            // Campos de prueba - CORREGIDO: Solo mostrar si no son nulos y no son fecha por defecto
            if (widget.mantenimiento.fecha_prueba_1 != null && 
                widget.mantenimiento.fecha_prueba_1!.year > 1900)
              Text('Fecha de prueba 1: ${_formatFecha(widget.mantenimiento.fecha_prueba_1)}'),
            if (widget.mantenimiento.fecha_prueba_2 != null && 
                widget.mantenimiento.fecha_prueba_2!.year > 1900)
              Text('Fecha de prueba 2: ${_formatFecha(widget.mantenimiento.fecha_prueba_2)}'),
            if (widget.mantenimiento.fecha_prueba != null && 
                widget.mantenimiento.fecha_prueba!.year > 1900)
              Text('Fecha de prueba: ${_formatFecha(widget.mantenimiento.fecha_prueba)}'),
            if (widget.mantenimiento.rt_fase_a != null)
              Text('RT. FASE A: ${widget.mantenimiento.rt_fase_a}'),
            if (widget.mantenimiento.rt_fase_b != null)
              Text('RT. FASE B: ${widget.mantenimiento.rt_fase_b}'),
            if (widget.mantenimiento.rt_fase_c != null)
              Text('RT. FASE C: ${widget.mantenimiento.rt_fase_c}'),
            if (widget.mantenimiento.resistencia_aislamiento_megaoms != 0)
              Text('Resistencia de Aislamiento: ${widget.mantenimiento.resistencia_aislamiento_megaoms}'),
            if (widget.mantenimiento.rigidez_dielecrica_kv.isNotEmpty)
              Text('Rigidez Dieléctrica: ${widget.mantenimiento.rigidez_dielecrica_kv}'),
            if (widget.mantenimiento.valor_prueba_1 != null && widget.mantenimiento.valor_prueba_1!.isNotEmpty)
              Text('Valor Prueba 1: ${widget.mantenimiento.valor_prueba_1}'),
            if (widget.mantenimiento.valor_prueba_2 != null && widget.mantenimiento.valor_prueba_2!.isNotEmpty)
              Text('Valor Prueba 2: ${widget.mantenimiento.valor_prueba_2}'),
            if (widget.mantenimiento.valor_prueba_3 != null && widget.mantenimiento.valor_prueba_3!.isNotEmpty)
              Text('Valor Prueba 3: ${widget.mantenimiento.valor_prueba_3}'),
            // Campos de fechas
            if (widget.mantenimiento.fecha_de_alta != null && 
                widget.mantenimiento.fecha_de_alta!.year > 1900)
              Text('Fecha de alta: ${_formatFecha(widget.mantenimiento.fecha_de_alta)}'),
            if (widget.mantenimiento.fecha_de_salida_del_taller != null && 
                widget.mantenimiento.fecha_de_salida_del_taller!.year > 1900)
              Text('Fecha de salida del taller: ${_formatFecha(widget.mantenimiento.fecha_de_salida_del_taller)}'),
            if (widget.mantenimiento.fecha_de_llegada != null && 
                widget.mantenimiento.fecha_de_llegada!.year > 1900)
              Text('Fecha de llegada: ${_formatFecha(widget.mantenimiento.fecha_de_llegada)}'),
            if (widget.mantenimiento.fecha_entrega_almacen != null && 
                widget.mantenimiento.fecha_entrega_almacen!.year > 1900)
              Text('Fecha entrega almacén: ${_formatFecha(widget.mantenimiento.fecha_entrega_almacen)}'),
            if (widget.mantenimiento.fechaMovimiento != null && 
                widget.mantenimiento.fechaMovimiento!.year > 1900)
              Text('Fecha de movimiento: ${_formatFecha(widget.mantenimiento.fechaMovimiento)}'),
            // Campos de mantenimiento
            if (widget.mantenimiento.salida_mantenimiento != null)
              Text('Salida mantenimiento: ${widget.mantenimiento.salida_mantenimiento! ? "Sí" : "No"}'),
            if (widget.mantenimiento.fecha_salida_mantenimiento != null && 
                widget.mantenimiento.fecha_salida_mantenimiento!.year > 1900)
              Text('Fecha salida mantenimiento: ${_formatFecha(widget.mantenimiento.fecha_salida_mantenimiento)}'),
            if (widget.mantenimiento.enviadoMantenimiento)
              Text('Enviado a mantenimiento: Sí'),
            if (widget.mantenimiento.fechaEnvioMantenimiento != null && 
                widget.mantenimiento.fechaEnvioMantenimiento!.year > 1900)
              Text('Fecha envío mantenimiento: ${_formatFecha(widget.mantenimiento.fechaEnvioMantenimiento)}'),

            // Campos adicionales
            if (widget.mantenimiento.estado.isNotEmpty)
              Text('Estado: ${widget.mantenimiento.estado}'),
            if (widget.mantenimiento.motivo != null && widget.mantenimiento.motivo!.isNotEmpty)
              Text('Motivo: ${widget.mantenimiento.motivo}'),
            if (widget.mantenimiento.contador != 0)
              Text('Contador: ${widget.mantenimiento.contador}'),
            if (widget.mantenimiento.zona != null && widget.mantenimiento.zona!.isNotEmpty)
              Text('Zona: ${widget.mantenimiento.zona}'),
            if (widget.mantenimiento.mes != null && widget.mantenimiento.mes!.isNotEmpty)
              Text('Mes: ${widget.mantenimiento.mes}'),
            if (widget.mantenimiento.consecutivo != null && widget.mantenimiento.consecutivo != 0)
              Text('Consecutivo: ${widget.mantenimiento.consecutivo}'),
            if (widget.mantenimiento.numEconomico != null && widget.mantenimiento.numEconomico != 0)
              Text('Número económico: ${widget.mantenimiento.numEconomico}'),
            if (widget.mantenimiento.relacion != null && widget.mantenimiento.relacion != 0)
              Text('Relación: ${widget.mantenimiento.relacion}'),
            if (widget.mantenimiento.status != null && widget.mantenimiento.status!.isNotEmpty)
              Text('Status: ${widget.mantenimiento.status}'),
            if (widget.mantenimiento.reparado != null)
              Text('Reparado: ${widget.mantenimiento.reparado! ? "Sí" : "No"}'),
            if (widget.mantenimiento.baja != null)
              Text('Baja: ${widget.mantenimiento.baja! ? "Sí" : "No"}'),
            if (widget.mantenimiento.cargas != null && widget.mantenimiento.cargas != 0)
              Text('Cargas: ${widget.mantenimiento.cargas}'),
            if (widget.mantenimiento.area_fecha_de_entrega_transformador_reparado != null &&
                widget.mantenimiento.area_fecha_de_entrega_transformador_reparado!.isNotEmpty)
              Text('Área/Fecha entrega transformador reparado: ${widget.mantenimiento.area_fecha_de_entrega_transformador_reparado}'),
            if (widget.mantenimiento.fechaReparacion != null && 
                widget.mantenimiento.fechaReparacion!.year > 1900)
              Text('Fecha de reparación: ${_formatFecha(widget.mantenimiento.fechaReparacion)}'),
            if (widget.mantenimiento.destinoReparado != null && widget.mantenimiento.destinoReparado!.isNotEmpty)
              Text('Destino: ${widget.mantenimiento.destinoReparado}'),

            const SizedBox(height: 12),

            MotivosList(
                collectionPath: 'mantenimiento2025',
                docId: widget.mantenimiento.id ?? ''),

            const SizedBox(height: 24),

            // BOTONES - SOLO CAMBIO EN LA LÓGICA DE VISIBILIDAD

            // Eliminar - SOLO SI NO ESTÁ EN MANTENIMIENTO
            if (widget.mantenimiento.estado.toLowerCase() != "en mantenimiento")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    final confirmar = await eliminarDialog(context);
                    if (confirmar == true) {
                      await provider.deleteMantenimientoProvider(widget.mantenimiento.id ?? '');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mantenimiento eliminado')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
                ),
              ),

            if (widget.mantenimiento.estado.toLowerCase() != "en mantenimiento")
              const SizedBox(height: 12),

            // Actualizar - SOLO SI NO ESTÁ EN MANTENIMIENTO
            if (widget.mantenimiento.estado.toLowerCase() != "en mantenimiento")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2A1AFF)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MantenimientoUpdateScreen(mantenimiento: widget.mantenimiento),
                      ),
                    ).then((_) {
                      provider.refreshData();
                    });
                  },
                  child: const Text('Actualizar', style: TextStyle(color: Colors.white)),
                ),
              ),

            if (widget.mantenimiento.estado.toLowerCase() != "en mantenimiento")
              const SizedBox(height: 12),

            // Exportar - SOLO SI NO ESTÁ EN MANTENIMIENTO
            if (widget.mantenimiento.estado.toLowerCase() != "en mantenimiento")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    await exportMantenimientosToExcel(context);
                  },
                  child: const Text('Exportar a xlsx', style: TextStyle(color: Colors.white)),
                ),
              ),

            if (widget.mantenimiento.estado.toLowerCase() != "en mantenimiento")
              const SizedBox(height: 12),

            // Marcar como reparado - SOLO SI NO ESTÁ REPARADO Y ESTÁ EN MANTENIMIENTO
            if (widget.mantenimiento.estado.toLowerCase() != "reparado")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  onPressed: () async {
                    await _marcarReparado(context, provider);
                  },
                  child: const Text("Marcar como reparado", style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
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
        if (widget.mantenimiento.estado.toLowerCase() != "reparado")
          _buildDisabledButton('Marcar como Reparado', Colors.cyan),
        const SizedBox(height: 12),
        if (widget.mantenimiento.estado.toLowerCase() != "en mantenimiento") ...[
          _buildDisabledButton('Eliminar', Colors.red),
          const SizedBox(height: 12),
          _buildDisabledButton('Actualizar', Color(0xFF2A1AFF)),
          const SizedBox(height: 12),
          _buildDisabledButton('Exportar a xlsx', Colors.green),
        ],
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

  Future<void> _marcarReparado(BuildContext context, MantenimientoProvider provider) async {
    String? destino = await _seleccionarDestino(context);

    if (destino != null) {
      final result = await marcarReparado(
        widget.mantenimiento.id ?? '',
        destinoManual: destino,
        mantenimiento: widget.mantenimiento,
      );

      if (result == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Transformador marcado como reparado y enviado a $destino")),
        );
        
        provider.refreshData();
        
        // Regresar a la pantalla anterior
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al marcar como reparado")),
        );
      }
    }
  }

  Future<String?> _seleccionarDestino(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Seleccionar destino"),
          content: const Text("¿A dónde quieres enviar este transformador?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, "transformadores2025"),
              child: const Text("Transformadores 2025"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, "Transformadoresxzona"),
              child: const Text("Transformadores por Zona"),
            ),
          ],
        );
      },
    );
  }
}