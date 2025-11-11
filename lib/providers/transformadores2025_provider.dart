import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';
import 'package:inventario_proyecto/services/transformadores_service.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Transformadores2025Provider extends ChangeNotifier {
  final List<Tranformadoresactuales> _transformadores = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Tranformadoresactuales> get transformadores => _transformadores;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Filtros activos
  String? selectedEstado;
  String? selectedMarca;
  String? selectedArea;
  String? selectedMes;
  int? selectedAceite;
  int? selectedPeso;
  int? selectedResistencia;
  String? selectedCargas;
  String? selectedFases;
  String? selectedCapacidad;
  String selectedField = "estado";

  // 🔄 Cargar todos los transformadores desde Firebase
  Future<void> fetchTransformadores() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final data = await getTranformadoresActuales();
      _transformadores
        ..clear()
        ..addAll(data);
    } catch (e) {
      _errorMessage = 'Error al obtener transformadores 2025: $e';
      debugPrint('❌ Error al obtener transformadores 2025: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ➕ Agregar transformador nuevo
  Future<void> addTransformadorProvider(Tranformadoresactuales nuevo) async {
    try {
      await addTransformador(nuevo);
      _transformadores.add(nuevo);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error al agregar transformador 2025: $e');
      rethrow;
    }
  }

  // ✏️ Actualizar transformador existente
  Future<void> updateTransformadorProvider(Tranformadoresactuales actualizado) async {
    try {
      await updateTransformador(actualizado);
      final index = _transformadores.indexWhere((t) => t.id == actualizado.id);
      if (index != -1) {
        _transformadores[index] = actualizado;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error al actualizar transformador 2025: $e');
      rethrow;
    }
  }

  // 🗑️ Eliminar transformador
  Future<void> deleteTransformadorProvider(String id) async {
    try {
      await deleteTransformadorActual(id);
      _transformadores.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error al eliminar transformador 2025: $e');
      rethrow;
    }
  }

  // 🔁 Enviar a mantenimiento CON NÚMERO AUTOMÁTICO Y TODOS LOS DATOS
  Future<int> enviarAMantenimientoProvider(String id, String motivo) async {
    try {
      // 1. Buscar el transformador en la lista local
      final transformador = _transformadores.firstWhere((t) => t.id == id);
      
      // 2. Preparar todos los datos del transformador
      final datosTransformador = {
        'area': transformador.area,
        'capacidadKVA': transformador.capacidadKVA,
        'economico': transformador.economico,
        'estado': transformador.estado,
        'fases': transformador.fases,
        'fecha_de_llegada': transformador.fecha_de_llegada,
        'mes': transformador.mes,
        'marca': transformador.marca,
        'aceite': transformador.aceite,
        'serie': transformador.serie,
        'peso_placa_de_datos': transformador.peso_placa_de_datos,
        'fecha_fabricacion': transformador.fecha_fabricacion,
        'fecha_prueba': transformador.fecha_prueba,
        'valor_prueba_1': transformador.valor_prueba_1,
        'valor_prueba_2': transformador.valor_prueba_2,
        'valor_prueba_3': transformador.valor_prueba_3,
        'resistencia_aislamiento_megaoms': transformador.resistencia_aislamiento_megaoms,
        'rigidez_dielecrica_kv': transformador.rigidez_dielecrica_kv,
        'fecha_de_entrada_al_taller': transformador.fecha_de_entrada_al_taller,
        'fecha_de_salida_del_taller': transformador.fecha_de_salida_del_taller,
        'fecha_entrega_almacen': transformador.fecha_entrega_almacen,
        'salida_mantenimiento': transformador.salida_mantenimiento,
        'fecha_salida_mantenimiento': transformador.fecha_salida_mantenimiento,
        'baja': transformador.baja,
        'cargas': transformador.cargas,
        'area_fecha_de_entrega_transformador_reparado': transformador.area_fecha_de_entrega_transformador_reparado,
        'motivo': transformador.motivo,
        'consecutivo': transformador.consecutivo,
      };
      
      // 3. Enviar a mantenimiento con número automático
      final result = await enviarAMantenimientoDesdeOtraPantalla(datosTransformador, motivo);
      
      if (result == 200) {
        // 4. Marcar como enviado a mantenimiento en el transformador original
        transformador.enviadoMantenimiento = true;
        transformador.fechaEnvioMantenimiento = DateTime.now();
        notifyListeners();
      }
      return result;
    } catch (e) {
      debugPrint('❌ Error al enviar a mantenimiento: $e');
      return 500;
    }
  }

  // 🔍 Aplicar filtros
  List<Tranformadoresactuales> get filteredTransformadores {
    List<Tranformadoresactuales> result = List.from(_transformadores);

    if (selectedEstado != null) {
      result = result.where((t) => t.estado == selectedEstado).toList();
    }
    if (selectedMarca != null) {
      result = result.where((t) => t.marca == selectedMarca).toList();
    }
    if (selectedArea != null) {
      result = result.where((t) => t.area == selectedArea).toList();
    }
    if (selectedMes != null) {
      result = result.where((t) => t.mes == selectedMes).toList();
    }
    if (selectedAceite != null) {
      result = result.where((t) => _extraerNumero(t.aceite) == selectedAceite).toList();
    }
    if (selectedPeso != null) {
      result = result.where((t) => _extraerNumero(t.peso_placa_de_datos) == selectedPeso).toList();
    }
    if (selectedCargas != null) {
      final parts = selectedCargas!.split("-");
      final min = int.parse(parts[0].trim());
      final max = int.parse(parts[1].trim());
      result = result.where((t) => t.cargas >= min && t.cargas <= max).toList();
    }
    if (selectedFases != null) {
      final parts = selectedFases!.split("-");
      final min = int.parse(parts[0].trim());
      final max = int.parse(parts[1].trim());
      result = result.where((t) => t.fases >= min && t.fases <= max).toList();
    }
    if (selectedCapacidad != null) {
      final parts = selectedCapacidad!.replaceAll("KVA", "").split("-");
      final min = int.parse(parts[0].trim());
      final max = int.parse(parts[1].trim());
      result = result.where((t) => t.capacidadKVA >= min && t.capacidadKVA <= max).toList();
    }
    if (selectedResistencia != null) {
      result = result.where((t) => t.resistencia_aislamiento_megaoms == selectedResistencia).toList();
    }

    return result;
  }

  // 🎯 Configurar filtro
  void setFilter({
    String? estado,
    String? marca,
    String? area,
    String? mes,
    int? aceite,
    int? peso,
    int? resistencia,
    String? cargas,
    String? fases,
    String? capacidad,
    String field = "estado",
  }) {
    selectedEstado = estado;
    selectedMarca = marca;
    selectedArea = area;
    selectedMes = mes;
    selectedAceite = aceite;
    selectedPeso = peso;
    selectedResistencia = resistencia;
    selectedCargas = cargas;
    selectedFases = fases;
    selectedCapacidad = capacidad;
    selectedField = field;
    notifyListeners();
  }

  // 🗑️ Limpiar filtros
  void clearFilters() {
    selectedEstado = null;
    selectedMarca = null;
    selectedArea = null;
    selectedMes = null;
    selectedAceite = null;
    selectedPeso = null;
    selectedResistencia = null;
    selectedCargas = null;
    selectedFases = null;
    selectedCapacidad = null;
    selectedField = "estado";
    notifyListeners();
  }

  // 🔧 Utilidad: extraer número de string
  int _extraerNumero(String valor) {
    return int.tryParse(valor.replaceAll(RegExp(r'[^0-9]'), "")) ?? 0;
  }

  // 🔄 Método para forzar actualización desde otras pantallas
  void refreshData() {
    fetchTransformadores();
  }
}