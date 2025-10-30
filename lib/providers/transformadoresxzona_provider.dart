import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';

class TransformadoresxZonaProvider extends ChangeNotifier {
  List<TransformadoresXZona> _allTransformadores = [];
  List<TransformadoresXZona> _filteredTransformadores = [];

  List<TransformadoresXZona> get transformadoresFiltrados => _filteredTransformadores;
  bool isLoading = false;

  String? selectedFilter;
  String? selectedValue;

  /// ✅ Obtiene todos los transformadores desde Firestore
  Future<void> fetchTransformadores(String zona) async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await getTransformadoresxZona();
      _allTransformadores = data;
      _filteredTransformadores = data;
    } catch (e) {
      debugPrint('❌ Error al obtener transformadores por zona: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Aplica filtros dinámicos
  void applyFilter(String? filter, String? value) {
    if (filter == null || value == null) {
      _filteredTransformadores = _allTransformadores;
      notifyListeners();
      return;
    }

    selectedFilter = filter;
    selectedValue = value;

    _filteredTransformadores = _allTransformadores.where((t) {
      switch (filter) {
        case 'capacidadKVA':
          final cap = t.capacidadKVA;
          final range = value.split('-');
          final min = double.tryParse(range[0]) ?? 0;
          final max = double.tryParse(range[1]) ?? double.infinity;
          return cap >= min && cap <= max;

        case 'Fases':
          final fases = t.fases;
          final range = value.split('-');
          final min = int.tryParse(range[0]) ?? 0;
          final max = int.tryParse(range[1]) ?? 0;
          return fases >= min && fases <= max;

        case 'Marca':
          return t.marca == value;

        case 'Status':
          return t.status.toLowerCase() == value.toLowerCase();

        case 'Peso':
          final peso = double.tryParse(t.peso_placa_de_datos.replaceAll('KGS', '').trim()) ?? 0;
          final range = value.split('-');
          final min = double.tryParse(range[0]) ?? 0;
          final max = double.tryParse(range[1]) ?? double.infinity;
          return peso >= min && peso <= max;

        case 'aceite':
          final aceite = double.tryParse(t.aceite.replaceAll('LTS', '').trim()) ?? 0;
          final range = value.split('-');
          final min = double.tryParse(range[0]) ?? 0;
          final max = double.tryParse(range[1]) ?? double.infinity;
          return aceite >= min && aceite <= max;

        default:
          return true;
      }
    }).toList();

    notifyListeners();
  }

  /// ✅ Limpia los filtros
  void clearFilters() {
    selectedFilter = null;
    selectedValue = null;
    _filteredTransformadores = _allTransformadores;
    notifyListeners();
  }

  /// ✅ Agregar un transformador
  Future<void> addTransformadorProvider(TransformadoresXZona nuevo) async {
    try {
      final result = await addTransformador(nuevo);
      if (result == 200) {
        _allTransformadores.add(nuevo);
        _filteredTransformadores = List.from(_allTransformadores);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error al agregar transformador: $e');
    }
  }

  /// ✅ Actualizar transformador
  Future<void> updateTransformadorProvider(TransformadoresXZona actualizado) async {
    try {
      final result = await updateTransformador(actualizado);
      if (result == 200) {
        final index = _allTransformadores.indexWhere((t) => t.id == actualizado.id);
        if (index != -1) {
          _allTransformadores[index] = actualizado;
          _filteredTransformadores = List.from(_allTransformadores);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('❌ Error al actualizar transformador: $e');
    }
  }

  /// ✅ Eliminar transformador
  Future<void> deleteTransformadorProvider(String id) async {
    try {
      final result = await deleteTransformadorZona(id);
      if (result == 200) {
        _allTransformadores.removeWhere((t) => t.id == id);
        _filteredTransformadores = List.from(_allTransformadores);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error al eliminar transformador: $e');
    }
  }

  /// ✅ Enviar a mantenimiento
  Future<int> enviarAMantenimientoProvider(String id, String motivo) async {
    try {
      final result = await enviarAMantenimientoZona(id, motivo);
      if (result == 200) {
        _allTransformadores.removeWhere((t) => t.id == id);
        _filteredTransformadores = List.from(_allTransformadores);
        notifyListeners();
      }
      return result;
    } catch (e) {
      debugPrint('❌ Error al enviar a mantenimiento: $e');
      return 500;
    }
  }

  /// ✅ Método para forzar actualización desde otras pantallas
  void refreshData(String zona) {
    fetchTransformadores(zona);
  }
}