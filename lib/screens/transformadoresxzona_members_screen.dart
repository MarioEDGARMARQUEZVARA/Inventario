import 'package:flutter/material.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_operations_screen.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_add_screen.dart';
import 'package:inventario_proyecto/providers/transformadoresxzona_provider.dart';
import 'package:provider/provider.dart';

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
  final int itemsPerPage = 7;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Cargar los transformadores al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TransformadoresxZonaProvider>();
      provider.fetchTransformadores(widget.zona);
    });
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
                double.tryParse(t.peso_placa_de_datos.replaceAll('KGS', '').trim()) ??
                0)
            .toList();
        final min = pesos.reduce((a, b) => a < b ? a : b);
        final max = pesos.reduce((a, b) => a > b ? a : b);
        return List.generate(((max - min) ~/ 10 + 1), (i) {
          final start = min + (i * 10);
          final end = start + 10;
          return '${start.toInt()}-${end.toInt()}';
        });

      case 'aceite':
        final aceite = data
            .map((t) => double.tryParse(
                t.aceite.replaceAll('LTS', '').trim())!)
            .toList();
        final min = aceite.reduce((a, b) => a < b ? a : b);
        final max = aceite.reduce((a, b) => a > b ? a : b);
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
          overlay.size.width, kToolbarHeight, 0, 0),
      items: options
          .map((opt) => PopupMenuItem<String>(
                value: opt,
                child: Text(opt),
              ))
          .toList(),
    );

    if (selected != null) {
      final provider = context.read<TransformadoresxZonaProvider>();
      provider.applyFilter(filter, selected);
      setState(() {
        currentPage = 0; // Resetear a la primera página al aplicar filtro
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Consumer<TransformadoresxZonaProvider>(
            builder: (context, provider, child) {
              final data = provider.transformadoresFiltrados
                  .where((t) => t.zona == widget.zona)
                  .toList();

              return PopupMenuButton<String>(
                icon: const Icon(Icons.filter_alt),
                onSelected: (value) {
                  if (value == "clear") {
                    provider.clearFilters();
                    setState(() {
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
                  const PopupMenuItem(value: 'aceite', child: Text('aceite')),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'clear', child: Text('Quitar filtro')),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<TransformadoresxZonaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          var transformadores = provider.transformadoresFiltrados
              .where((t) => t.zona == widget.zona)
              .toList();

          if (transformadores.isEmpty) {
            return const Center(
                child: Text('No hay transformadores registrados.'));
          }

          // Paginación
          final totalPages = (transformadores.length / itemsPerPage).ceil();
          final start = currentPage * itemsPerPage;
          final end = (start + itemsPerPage).clamp(0, transformadores.length);
          final pageItems = transformadores.sublist(start, end);

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    // Mostrar filtro activo si existe
                    if (provider.selectedFilter != null && provider.selectedValue != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filtro: ${provider.selectedFilter} = ${provider.selectedValue}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: () {
                                provider.clearFilters();
                                setState(() {
                                  currentPage = 0;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: pageItems.length,
                        itemBuilder: (context, index) {
                          final t = pageItems[index];
                          return InkWell(
                            onTap: () {
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
                                    t.serie,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    provider.selectedFilter != null
                                        ? "${provider.selectedFilter}: ${provider.selectedValue}"
                                        : "Status: ${t.status}",
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
          );
        },
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