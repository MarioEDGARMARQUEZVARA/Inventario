import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_operations_screen.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_add_screen.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';

// Modelo de ejemplo
class Tranformadoresactuales {
  final String zona;
  final String status;
  final int cargas;
  final int peso;
  final int litros;
  final int fases;
  final int capacidad;

  Tranformadoresactuales({
    required this.zona,
    required this.status,
    required this.cargas,
    required this.peso,
    required this.litros,
    required this.fases,
    required this.capacidad,
  });
}

class TransformadoresxzonaMembersScreen extends StatefulWidget {
  final String zona;

  const TransformadoresxzonaMembersScreen({
    super.key,
    required this.zona,
  });

  @override
  State<TransformadoresxzonaMembersScreen> createState() =>
      _TransformadoresxzonaMembersScreenState();
}

class _TransformadoresxzonaMembersScreenState
    extends State<TransformadoresxzonaMembersScreen> {
  List<Tranformadoresactuales> allData = [];
  List<Tranformadoresactuales> filteredData = [];

  String? activeFilterType;
  String? activeFilterValue;

  int currentPage = 0;
  final int pageSize = 6;
  final int itemsPerPage = 7;

  String? selectedFilter;
  String? selectedFilterValue;

  @override
  void initState() {
    super.initState();
    // Datos de ejemplo
    allData = List.generate(
      25,
      (index) => Tranformadoresactuales(
        zona: index % 2 == 0 ? "Zacapoxtla" : "Oaxaca",
        status: index % 3 == 0 ? "Activo" : "Inactivo",
        cargas: (index * 7) % 100,
        peso: (index * 5) % 100,
        litros: (index * 3) % 100,
        fases: [1, 2, 3][index % 3],
        capacidad: [50, 100, 150, 200][index % 4],
      ),
    );
    filteredData = List.from(allData);
  }

  List<TransformadoresXZona> applyFilters(List<TransformadoresXZona> data) {
    if (selectedFilter == null || selectedFilterValue == null) return data;

    return data.where((t) {
      switch (selectedFilter) {
        case 'Capacidad':
          final cap = t.capacidad;
          final range = selectedFilterValue!.split('-');
          final min = double.parse(range[0]);
          final max = double.parse(range[1]);
          return cap >= min && cap <= max;

        case 'Fases':
          final fases = t.fase;
          final range = selectedFilterValue!.split('-');
          final min = int.parse(range[0]);
          final max = int.parse(range[1]);
          return fases >= min && fases <= max;

        case 'Marca':
          return t.marca == selectedFilterValue;

        case 'Status':
          return (t.status).toLowerCase() ==
              selectedFilterValue!.toLowerCase();

        case 'Peso':
          final peso = double.tryParse(
                  t.pesoKg.replaceAll('KGS', '').trim()) ??
              0;
          final range = selectedFilterValue!.split('-');
          final min = double.parse(range[0]);
          final max = double.parse(range[1]);
          return peso >= min && peso <= max;

        case 'Litros':
          final litros = double.tryParse(
                  t.litros.replaceAll('LTS', '').trim()) ??
              0;
          final range = selectedFilterValue!.split('-');
          final min = double.parse(range[0]);
          final max = double.parse(range[1]);
          return litros >= min && litros <= max;

        default:
          return true;
      }
    }).toList();
  }

  List<String> getDynamicOptions(
      List<TransformadoresXZona> data, String filterType) {
    switch (filterType) {
      case 'Capacidad':
        return List.generate(10, (i) {
          final start = i * 10.0;
          final end = start + 10.0;
          return '${start.toInt()}-${end.toInt()}';
        });

      case 'Fases':
        return List.generate(10, (i) {
          final value = i + 1;
          return '$value-$value';
        });

      case 'Marca':
        return data.map((t) => t.marca).toSet().toList();

      case 'Status':
        return data.map((t) => t.status).toSet().toList();

      case 'Peso':
        final pesos = data
            .map((t) =>
                double.tryParse(t.pesoKg.replaceAll('KGS', '').trim()) ??
                0)
            .toList();
        final min = pesos.reduce((a, b) => a < b ? a : b);
        final max = pesos.reduce((a, b) => a > b ? a : b);
        return List.generate(((max - min) ~/ 10 + 1), (i) {
          final start = min + (i * 10);
          final end = start + 10;
          return '${start.toInt()}-${end.toInt()}';
        });

      case 'Litros':
        final litros = data
            .map((t) => double.tryParse(
                t.litros.replaceAll('LTS', '').trim())!)
            .toList();
        final min = litros.reduce((a, b) => a < b ? a : b);
        final max = litros.reduce((a, b) => a > b ? a : b);
        return List.generate(((max - min) ~/ 10 + 1), (i) {
          final start = min + (i * 10);
          final end = start + 10;
          return '${start.toInt()}-${end.toInt()}';
        });

      default:
        return [];
    }
  }

  Future<void> _showSubMenu(
      BuildContext context, String filter, List<TransformadoresXZona> data) async {
    final options = getDynamicOptions(data, filter);
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
          overlay.size.width, kToolbarHeight, 0, 0), // esquina superior derecha
      items: options
          .map((opt) => PopupMenuItem<String>(
                value: opt,
                child: Text(opt),
              ))
          .toList(),
    );

    if (selected != null) {
      setState(() {
        selectedFilter = filter;
        selectedFilterValue = selected;
      });
    }
  }

  void applyFilter(String filterType, String value) {
    setState(() {
      activeFilterType = filterType;
      activeFilterValue = value;

      if (filterType == "cargas" || filterType == "peso" || filterType == "litros") {
        final range = value.split("-");
        final min = int.parse(range[0]);
        final max = int.parse(range[1]);
        filteredData = allData.where((e) {
          final val = filterType == "cargas"
              ? e.cargas
              : filterType == "peso"
                  ? e.peso
                  : e.litros;
          return val >= min && val <= max;
        }).toList();
      } else if (filterType == "fases") {
        filteredData = allData.where((e) => e.fases.toString() == value).toList();
      } else if (filterType == "capacidad") {
        filteredData = allData.where((e) => e.capacidad.toString() == value).toList();
      } else {
        filteredData = List.from(allData);
      }
      currentPage = 0;
    });
  }

  void clearFilter() {
    setState(() {
      activeFilterType = null;
      activeFilterValue = null;
      filteredData = List.from(allData);
      currentPage = 0;
    });
  }

  List<Tranformadoresactuales> get paginatedData {
    final start = currentPage * pageSize;
    final end = start + pageSize;
    return filteredData.sublist(start, end > filteredData.length ? filteredData.length : end);
  }

  void _showSubFilterMenu(BuildContext context, String filterType, List<String> options) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Offset(50, 80) & const Size(40, 40), // Posición del popup
        Offset.zero & overlay.size,
      ),
      items: options.map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
    );
    if (result != null) {
      applyFilter(filterType, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (filteredData.length / pageSize).ceil();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1AFF),
        title: Text(
          'ZONA: ${widget.zona.toUpperCase()}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          StreamBuilder<List<TransformadoresXZona>>(
            stream: transformadoresxzonaStream(),
            builder: (context, snapshot) {
              final data = (snapshot.data ?? [])
                  .where((t) => t.zona == widget.zona)
                  .toList();

              return PopupMenuButton<String>(
                icon: const Icon(Icons.filter_alt),
                onSelected: (value) {
                  if (value == "clear") {
                    setState(() {
                      selectedFilter = null;
                      selectedFilterValue = null;
                      currentPage = 0;
                    });
                  } else if (value != null) {
                    _showSubMenu(context, value, data);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'Capacidad', child: Text('Capacidad')),
                  const PopupMenuItem(value: 'Fases', child: Text('Fases')),
                  const PopupMenuItem(value: 'Marca', child: Text('Marca')),
                  const PopupMenuItem(value: 'Status', child: Text('Status')),
                  const PopupMenuItem(value: 'Peso', child: Text('Peso')),
                  const PopupMenuItem(value: 'Litros', child: Text('Litros')),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'clear', child: Text('Quitar filtro')),
                ],
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: StreamBuilder<List<TransformadoresXZona>>(
              stream: transformadoresxzonaStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var transformadores = (snapshot.data ?? [])
                    .where((t) => t.zona == widget.zona)
                    .toList();

                // aplicar filtros
                transformadores = applyFilters(transformadores);

                if (transformadores.isEmpty) {
                  return const Center(
                      child: Text('No hay transformadores registrados.'));
                }

                // paginación
                final totalPages =
                    (transformadores.length / itemsPerPage).ceil();
                final start = currentPage * itemsPerPage;
                final end =
                    (start + itemsPerPage).clamp(0, transformadores.length);
                final pageItems = transformadores.sublist(start, end);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: pageItems.length,
                        itemBuilder: (context, index) {
                          final t = pageItems[index];
                          return InkWell(
                            onTap: () {
                              // Debug: imprimir datos antes de navegar
                              try {
                                // ignore: avoid_print
                                print('NAVIGATE Transformadoresxzona -> ${t.toJson()}');
                              } catch (_) {}
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TrasnformadoresxzonaOperationsScreen(
                                          transformador: t),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              padding: const EdgeInsets.all(8),
                              color: Colors.grey[300],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.numeroDeSerie,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    selectedFilterValue != null
                                        ? "$selectedFilter: $selectedFilterValue"
                                        : "Status: ${t.status }",
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (totalPages > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: currentPage > 0
                                ? () => setState(() => currentPage--)
                                : null,
                          ),
                          Text("Página ${currentPage + 1} de $totalPages"),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: currentPage < totalPages - 1
                                ? () => setState(() => currentPage++)
                                : null,
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Aquí va la lógica para exportar a xlsx
                  },
                  child: const Text(
                    'Exportar a xlsx',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2196F3),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TransformadoresxzonaAddScreen(zona: widget.zona),
            ),
          );
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
