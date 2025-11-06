import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';

class MantenimientoProvider extends ChangeNotifier {
  final List<Mantenimiento> _mantenimientos = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Mantenimiento> get mantenimientos => _mantenimientos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Filtros activos
  String? selectedEstado;
  String? selectedMarca;
  String? selectedArea;
  String? selectedLitros;
  String? selectedCapacidad;
  String? selectedPesoPlacaDeDatos;
  String? selectedFases;
  String? selectedAceite; // nuevo filtro
  String? selectedResistenciaAislamientoMegaoms; // nuevo filtro
  String selectedField = "estado";

  // 🔄 Cargar todos los mantenimientos desde Firebase
  Future<void> fetchMantenimientos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final data = await getMantenimientos();
      _mantenimientos
        ..clear()
        ..addAll(data);
    } catch (e) {
      _errorMessage = 'Error al cargar mantenimientos: $e';
      debugPrint('❌ Error al cargar mantenimientos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ➕ Agregar nuevo mantenimiento
  Future<void> addMantenimientoProvider(Mantenimiento mantenimiento) async {
    try {
      await addMantenimiento(mantenimiento);
      _mantenimientos.add(mantenimiento);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error al agregar mantenimiento: $e');
      rethrow;
    }
  }

  // ✏️ Actualizar mantenimiento existente
  Future<void> updateMantenimientoProvider(Mantenimiento mantenimiento) async {
    try {
      await updateMantenimiento(mantenimiento);
      final index = _mantenimientos.indexWhere((m) => m.id == mantenimiento.id);
      if (index != -1) {
        _mantenimientos[index] = mantenimiento;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error al actualizar mantenimiento: $e');
      rethrow;
    }
  }

  // 🗑️ Eliminar mantenimiento
  Future<void> deleteMantenimientoProvider(String id) async {
    try {
      await deleteMantenimiento(id);
      _mantenimientos.removeWhere((m) => m.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error al eliminar mantenimiento: $e');
      rethrow;
    }
  }

  // 🔁 Marcar como reparado (actualizar estado en lugar de eliminar)
  Future<int> marcarReparadoProvider(String id, {String? destinoManual}) async {
    try {
      final result = await marcarReparado(id, destinoManual: destinoManual);
      if (result == 200) {
        // Actualizar el estado localmente
        final mantenimiento = _mantenimientos.firstWhere((m) => m.id == id);
        mantenimiento.estado = "reparado";
        mantenimiento.fechaReparacion = DateTime.now();
        mantenimiento.destinoReparado = destinoManual ?? "transformadores2025";
        notifyListeners();
      }
      return result;
    } catch (e) {
      debugPrint('❌ Error al marcar como reparado: $e');
      return 500;
    }
  }

  // 🔍 Aplicar filtros
  List<Mantenimiento> get filteredMantenimientos {
    List<Mantenimiento> result = List.from(_mantenimientos);

    if (selectedEstado != null) {
      result = result.where((m) => m.estado == selectedEstado).toList();
    }
    if (selectedMarca != null) {
      result = result.where((m) => m.marca == selectedMarca).toList();
    }
    if (selectedArea != null) {
      result = result.where((m) => m.area == selectedArea).toList();
    }
    if (selectedLitros != null) {
      final parts = selectedLitros!.split("-");
      final min = int.parse(parts[0].trim());
      final max = int.parse(parts[1].trim());
      result = result.where((m) {
        final litrosInt = _parseUnidad(m.aceite);
        return litrosInt >= min && litrosInt <= max;
      }).toList();
    }
    if (selectedCapacidad != null) {
      final parts = selectedCapacidad!.split("-");
      final min = int.parse(parts[0].trim());
      final max = int.parse(parts[1].trim());
      result = result.where((m) {
        final capacidadInt = _parseUnidad(m.capacidadKVA.toString());
        return capacidadInt >= min && capacidadInt <= max;
      }).toList();
    }
    if (selectedPesoPlacaDeDatos != null) {
      final parts = selectedPesoPlacaDeDatos!.split("-");
      final min = int.parse(parts[0].trim());
      final max = int.parse(parts[1].trim());
      result = result.where((m) {
        final kilosInt = _parseUnidad(m.peso_placa_de_datos);
        return kilosInt >= min && kilosInt <= max;
      }).toList();
    }
    if (selectedFases != null) {
      final parts = selectedFases!.split("-");
      final min = int.parse(parts[0].trim());
      final max = int.parse(parts[1].trim());
      result = result.where((m) => m.fases >= min && m.fases <= max).toList();
    }
    if (selectedAceite != null) {
      result = result.where((m) => m.aceite == selectedAceite).toList();
    }
    if (selectedResistenciaAislamientoMegaoms != null) {
      final parts = selectedResistenciaAislamientoMegaoms!.split("-");
      final min = int.parse(parts[0].trim());
      final max = int.parse(parts[1].trim());
      result = result.where((m) =>
        m.resistencia_aislamiento_megaoms >= min &&
        m.resistencia_aislamiento_megaoms <= max
      ).toList();
    }

    return result;
  }

  // 🎯 Configurar filtro
  void setFilter({
    String? estado,
    String? marca,
    String? area,
    String? litros,
    String? capacidad,
    String? peso_placa_de_datos,
    String? fases,
    String? aceite,
    String? resistencia_aislamiento_megaoms,
    String field = "estado",
  }) {
    selectedEstado = estado;
    selectedMarca = marca;
    selectedArea = area;
    selectedLitros = litros;
    selectedCapacidad = capacidad;
    selectedPesoPlacaDeDatos = peso_placa_de_datos;
    selectedFases = fases;
    selectedAceite = aceite;
    selectedResistenciaAislamientoMegaoms = resistencia_aislamiento_megaoms;
    selectedField = field;
    notifyListeners();
  }

  // 🗑️ Limpiar filtros
  void clearFilters() {
    selectedEstado = null;
    selectedMarca = null;
    selectedArea = null;
    selectedLitros = null;
    selectedCapacidad = null;
    selectedPesoPlacaDeDatos = null;
    selectedFases = null;
    selectedAceite = null;
    selectedResistenciaAislamientoMegaoms = null;
    selectedField = "estado";
    notifyListeners();
  }

  // 🔧 Utilidad: extraer número de string con unidad
  int _parseUnidad(String value) {
    final numberString = RegExp(r'\d+').stringMatch(value) ?? "0";
    return int.parse(numberString);
  }

  // 📊 Generar rangos dinámicos para filtros
  List<String> generarRangos(int inicio, int fin, int paso) {
    List<String> rangos = [];
    for (int i = inicio; i <= fin; i += paso) {
      rangos.add("$i - ${i + paso - 1}");
    }
    return rangos;
  }

  // 🔍 Obtener valores únicos para filtros
  Map<String, List<String>> getUniqueValues() {
    return {
      "estado": _mantenimientos.map((m) => m.estado).toSet().toList(),
      "marca": _mantenimientos.map((m) => m.marca).toSet().toList(),
      "area": _mantenimientos.map((m) => m.area).toSet().toList(),
      "aceite": _mantenimientos.map((m) => m.aceite).toSet().toList(),
      "resistencia_aislamiento_megaoms": _mantenimientos.map((m) => m.resistencia_aislamiento_megaoms.toString()).toSet().toList(),
    };
  }

  // 🔄 Método para forzar actualización desde otras pantallas
  void refreshData() {
    fetchMantenimientos();
  }
}