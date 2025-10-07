import 'package:flutter/material.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:inventario_proyecto/screens/mantenimiento_operations_screen.dart';
import 'package:inventario_proyecto/screens/mantenimiento_add_screen.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';

class MantenimientoScreen extends StatefulWidget {
  const MantenimientoScreen({super.key});

  @override
  State<MantenimientoScreen> createState() => _MantenimientoScreenState();
}

class _MantenimientoScreenState extends State<MantenimientoScreen> {
  String? selectedEstado;
  String? selectedMarca;
  String? selectedArea;
  String? selectedLitros;
  String? selectedCapacidad;
  String? selectedKilos;
  String? selectedFases;

  String selectedField = "estado"; // subtítulo por defecto

  // Paginación
  int currentPage = 0;
  final int itemsPerPage = 6;

  // genera rangos dinámicos
  List<String> generarRangos(int inicio, int fin, int paso) {
    List<String> rangos = [];
    for (int i = inicio; i <= fin; i += paso) {
      rangos.add("$i - ${i + paso - 1}");
    }
    return rangos;
  }

  // extrae solo el número de un string con unidad
  int parseUnidad(String value) {
    final numberString = RegExp(r'\d+').stringMatch(value) ?? "0";
    return int.parse(numberString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1AFF),
        title: const Text(
          'Mantenimiento',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          StreamBuilder<List<Mantenimiento>>(
            stream: mantenimientosStream(),
            builder: (context, snapshot) {
              final mantenimientos = snapshot.data ?? [];

              final uniqueValues = {
                "estado": mantenimientos.map((m) => m.estado).toSet().toList(),
                "marca": mantenimientos.map((m) => m.marca).toSet().toList(),
                "area": mantenimientos.map((m) => m.area).toSet().toList(),
              };

              return PopupMenuButton<String>(
                icon: const Icon(Icons.filter_alt, color: Colors.white),
                onSelected: (value) async {
                  if (value == "clear") {
                    setState(() {
                      selectedEstado = null;
                      selectedMarca = null;
                      selectedArea = null;
                      selectedLitros = null;
                      selectedCapacidad = null;
                      selectedKilos = null;
                      selectedFases = null;
                      selectedField = "estado";
                      currentPage = 0;
                    });
                    return;
                  }

                  setState(() {
                    selectedField = value;
                  });

                  List<String> values = [];

                  if (value == "estado" || value == "marca" || value == "area") {
                    values = uniqueValues[value] ?? [];
                  } else if (value == "litros") {
                    values = generarRangos(0, 150, 10);
                  } else if (value == "capacidad") {
                    values = generarRangos(0, 150, 10);
                  } else if (value == "kilos") {
                    values = generarRangos(0, 1000, 100);
                  } else if (value == "fases") {
                    values = generarRangos(1, 10, 1);
                  }

                  final selected = await showDialog<String>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text("Selecciona un $value"),
                      children: values
                          .map((val) => SimpleDialogOption(
                                child: Text(val),
                                onPressed: () {
                                  Navigator.pop(context, val);
                                },
                              ))
                          .toList(),
                    ),
                  );

                  if (selected != null) {
                    setState(() {
                      selectedEstado = null;
                      selectedMarca = null;
                      selectedArea = null;
                      selectedLitros = null;
                      selectedCapacidad = null;
                      selectedKilos = null;
                      selectedFases = null;

                      if (value == "estado") selectedEstado = selected;
                      if (value == "marca") selectedMarca = selected;
                      if (value == "area") selectedArea = selected;
                      if (value == "litros") selectedLitros = selected;
                      if (value == "capacidad") selectedCapacidad = selected;
                      if (value == "kilos") selectedKilos = selected;
                      if (value == "fases") selectedFases = selected;
                      currentPage = 0;
                    });
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: "estado", child: Text("Filtrar por Estado")),
                  PopupMenuItem(value: "marca", child: Text("Filtrar por Marca")),
                  PopupMenuItem(value: "area", child: Text("Filtrar por Área")),
                  PopupMenuItem(value: "litros", child: Text("Filtrar por Litros")),
                  PopupMenuItem(value: "capacidad", child: Text("Filtrar por Capacidad")),
                  PopupMenuItem(value: "kilos", child: Text("Filtrar por Kilos")),
                  PopupMenuItem(value: "fases", child: Text("Filtrar por Fases")),
                  PopupMenuDivider(),
                  PopupMenuItem(value: "clear", child: Text("Quitar filtro")),
                ],
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Mantenimiento>>(
        stream: mantenimientosStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var mantenimientos = snapshot.data ?? [];

          // aplicar filtros
          if (selectedEstado != null) {
            mantenimientos =
                mantenimientos.where((m) => m.estado == selectedEstado).toList();
          }
          if (selectedMarca != null) {
            mantenimientos =
                mantenimientos.where((m) => m.marca == selectedMarca).toList();
          }
          if (selectedArea != null) {
            mantenimientos =
                mantenimientos.where((m) => m.area == selectedArea).toList();
          }
          if (selectedLitros != null) {
            final parts = selectedLitros!.split("-");
            final min = int.parse(parts[0].trim());
            final max = int.parse(parts[1].trim());
            mantenimientos = mantenimientos.where((m) {
              final litrosInt = parseUnidad(m.litros);
              return litrosInt >= min && litrosInt <= max;
            }).toList();
          }
          if (selectedCapacidad != null) {
            final parts = selectedCapacidad!.split("-");
            final min = int.parse(parts[0].trim());
            final max = int.parse(parts[1].trim());
            mantenimientos = mantenimientos.where((m) {
              final capacidadInt = parseUnidad(m.capacidad.toString());
              return capacidadInt >= min && capacidadInt <= max;
            }).toList();
          }
          if (selectedKilos != null) {
            final parts = selectedKilos!.split("-");
            final min = int.parse(parts[0].trim());
            final max = int.parse(parts[1].trim());
            mantenimientos = mantenimientos.where((m) {
              final kilosInt = parseUnidad(m.kilos);
              return kilosInt >= min && kilosInt <= max;
            }).toList();
          }
          if (selectedFases != null) {
            final parts = selectedFases!.split("-");
            final min = int.parse(parts[0].trim());
            final max = int.parse(parts[1].trim());
            mantenimientos = mantenimientos
                .where((m) => m.fases >= min && m.fases <= max)
                .toList();
          }

          if (mantenimientos.isEmpty) {
            return const Center(
                child: Text('No hay reportes de mantenimiento registrados.'));
          }

          // Paginación
          final totalPages = (mantenimientos.length / itemsPerPage).ceil();
          final startIndex = currentPage * itemsPerPage;
          final endIndex = (startIndex + itemsPerPage > mantenimientos.length)
              ? mantenimientos.length
              : startIndex + itemsPerPage;
          final pageItems = mantenimientos.sublist(startIndex, endIndex);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) {
                    final m = pageItems[index];

                    String subtitleValue = "";
                    switch (selectedField) {
                      case "marca":
                        subtitleValue = "Marca: ${m.marca}";
                        break;
                      case "area":
                        subtitleValue = "Área: ${m.area}";
                        break;
                      case "litros":
                        subtitleValue = "Litros: ${m.litros}";
                        break;
                      case "capacidad":
                        subtitleValue = "Capacidad: ${m.capacidad}";
                        break;
                      case "kilos":
                        subtitleValue = "Kilos: ${m.kilos}";
                        break;
                      case "fases":
                        subtitleValue = "Fases: ${m.fases}";
                        break;
                      default:
                        subtitleValue = "Estado: ${m.estado}";
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          "MANTENIMIENTO ${m.numero_mantenimiento}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          subtitleValue,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MantenimientoOperationsScreen(mantenimiento: m),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      // lógica de exportar se agregará después
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Exportar a xlsx",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
              // Controles de paginación
              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text("Página ${currentPage + 1} de $totalPages"),
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
            MaterialPageRoute(builder: (_) => const MantenimientoAddScreen()),
          );
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
