import 'package:flutter/material.dart';
import 'package:inventario_proyecto/services/transformadoresxzona_service.dart';
import 'package:inventario_proyecto/models/transformadoresxzona.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_members_screen.dart';
import 'package:inventario_proyecto/screens/transformadoresxzona_add_screen.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class TransformadoresxzonaScreen extends StatefulWidget {
  const TransformadoresxzonaScreen({super.key});

  @override
  State<TransformadoresxzonaScreen> createState() =>
      _TransformadoresxzonaScreenState();
}

class _TransformadoresxzonaScreenState
    extends State<TransformadoresxzonaScreen> {
  int currentPage = 0;
  int itemsPerPage = 6;
  RangeValues? selectedRange; 

  @override
  void initState() {
    super.initState();
    // Iniciar sesión de inactividad
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sessionProvider = context.read<SessionProvider>();
      sessionProvider.startSession();
    });
  }

  List<MapEntry<String, List<TransformadoresXZona>>> applyFilter(
      Map<String, List<TransformadoresXZona>> zonas) {
    final zonaEntries = zonas.entries.toList();

    if (selectedRange == null) {
      return zonaEntries;
    }

    return zonaEntries.where((entry) {
      final cantidad = entry.value.length;
      return cantidad >= selectedRange!.start &&
          cantidad <= selectedRange!.end;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: sessionProvider.showTimeoutDialog 
            ? Colors.orange 
            : const Color(0xFF2A1AFF),
        title: const Text(
          'Transformadores en la zona',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onSelected: sessionProvider.showTimeoutDialog 
                ? null 
                : (value) {
                    setState(() {
                      if (value == "clear") {
                        selectedRange = null;
                        currentPage = 0;
                      } else {
                        final parts = value.split("-");
                        selectedRange = RangeValues(
                            double.parse(parts[0]), double.parse(parts[1]));
                        currentPage = 0;
                      }
                    });
                  },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "0-10", child: Text("0 - 10")),
              const PopupMenuItem(value: "11-20", child: Text("11 - 20")),
              const PopupMenuItem(value: "21-30", child: Text("21 - 30")),
              const PopupMenuItem(value: "31-40", child: Text("31 - 40")),
              const PopupMenuItem(value: "41-50", child: Text("41 - 50")),
              const PopupMenuItem(value: "51-60", child: Text("51 - 60")),
              const PopupMenuItem(value: "61-70", child: Text("61 - 70")),
              const PopupMenuItem(value: "71-80", child: Text("71 - 80")),
              const PopupMenuItem(value: "81-90", child: Text("81 - 90")),
              const PopupMenuItem(value: "91-100", child: Text("91 - 100")),
              const PopupMenuDivider(),
              const PopupMenuItem(value: "clear", child: Text("Quitar filtro")),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 140),
            child: sessionProvider.showTimeoutDialog
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer, size: 50, color: Colors.orange),
                        SizedBox(height: 16),
                        Text(
                          'Sesión por expirar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Abre el menú lateral para extender tu sesión',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : StreamBuilder<List<TransformadoresXZona>>(
                    stream: transformadoresxzonaStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text("Ocurrió un error al cargar los datos."));
                      }
                      final data = snapshot.data ?? [];
                      if (data.isEmpty) {
                        return const Center(
                            child: Text('No hay transformadores registrados.'));
                      }

                      // Agrupar por zona
                      final Map<String, List<TransformadoresXZona>> zonas = {};
                      for (var t in data) {
                        zonas.putIfAbsent(t.zona, () => []).add(t);
                      }

                      // Filtrar según rango seleccionado
                      final zonaEntries = applyFilter(zonas);

                      if (zonaEntries.isEmpty) {
                        return const Center(
                            child: Text("No hay registros en este rango."));
                      }

                      // Paginación
                      final totalPages =
                          (zonaEntries.length / itemsPerPage).ceil().clamp(1, 999);
                      final start = currentPage * itemsPerPage;
                      final end = (start + itemsPerPage) > zonaEntries.length
                          ? zonaEntries.length
                          : (start + itemsPerPage);
                      final pageItems = zonaEntries.sublist(start, end);

                      return ListView.builder(
                        itemCount: pageItems.length,
                        itemBuilder: (context, index) {
                          final zona = pageItems[index].key;
                          final cantidad = pageItems[index].value.length;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            child: ListTile(
                              title: Text(
                                zona.toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Text(
                                'Cantidad: $cantidad',
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 14),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TransformadoresxzonaMembersScreen(zona: zona),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          // Botón exportar + paginación debajo
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 180,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sessionProvider.showTimeoutDialog 
                            ? Colors.grey 
                            : Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: sessionProvider.showTimeoutDialog 
                          ? null 
                          : () async {
                              await exportTransformadoresxzonaToExcel(context);
                            },
                      child: const Text(
                        'Exportar a xlsx',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!sessionProvider.showTimeoutDialog)
                    StreamBuilder<List<TransformadoresXZona>>(
                      stream: transformadoresxzonaStream(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox();
                        final data = snapshot.data!;
                        final zonas = <String, List<TransformadoresXZona>>{};
                        for (var t in data) {
                          zonas.putIfAbsent(t.zona, () => []).add(t);
                        }
                        final zonaEntries = applyFilter(zonas);
                        final totalPages =
                            (zonaEntries.length / itemsPerPage).ceil().clamp(1, 999);

                        if (totalPages <= 1) return const SizedBox();

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: currentPage > 0
                                  ? () {
                                      setState(() {
                                        currentPage--;
                                      });
                                    }
                                  : null,
                              child: const Text("Anterior"),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "Página ${currentPage + 1} de $totalPages",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: currentPage < totalPages - 1
                                  ? () {
                                      setState(() {
                                        currentPage++;
                                      });
                                    }
                                  : null,
                              child: const Text("Siguiente"),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: sessionProvider.showTimeoutDialog
          ? FloatingActionButton(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Icon(Icons.warning),
            )
          : FloatingActionButton(
              backgroundColor: const Color(0xFF2196F3),
              onPressed: sessionProvider.showTimeoutDialog 
                  ? null 
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransformadoresxzonaAddScreen(),
                        ),
                      );
                    },
              child: const Icon(Icons.add, size: 32),
            ),
    );
  }
}