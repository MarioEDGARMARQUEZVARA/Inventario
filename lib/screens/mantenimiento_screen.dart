import 'package:flutter/material.dart';
import 'package:inventario_proyecto/providers/mantenimento_provider.dart';
import 'package:inventario_proyecto/services/mantenimiento_service.dart';
import 'package:inventario_proyecto/models/mantenimiento.dart';
import 'package:inventario_proyecto/screens/mantenimiento_operations_screen.dart';
import 'package:inventario_proyecto/screens/mantenimiento_add_screen.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';
import 'package:provider/provider.dart';


class MantenimientoScreen extends StatefulWidget {
  const MantenimientoScreen({super.key});

  @override
  State<MantenimientoScreen> createState() => _MantenimientoScreenState();
}

class _MantenimientoScreenState extends State<MantenimientoScreen> {
  int currentPage = 0;
  final int itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MantenimientoProvider>();
      provider.fetchMantenimientos();
    });
  }

  Widget _buildFilterButton() {
    return Consumer<MantenimientoProvider>(
      builder: (context, provider, child) {
        final uniqueValues = provider.getUniqueValues();

        return PopupMenuButton<String>(
          icon: const Icon(Icons.filter_alt, color: Colors.white),
          onSelected: (value) async {
            if (value == "clear") {
              provider.clearFilters();
              setState(() {
                currentPage = 0;
              });
              return;
            }

            List<String> values = [];

            if (value == "estado" || value == "marca" || value == "area") {
              values = uniqueValues[value] ?? [];
            } else if (value == "litros") {
              values = provider.generarRangos(0, 150, 10);
            } else if (value == "capacidad") {
              values = provider.generarRangos(0, 150, 10);
            } else if (value == "peso_placa_de_datos") {
              values = provider.generarRangos(0, 1000, 100);
            } else if (value == "fases") {
              values = provider.generarRangos(1, 10, 1);
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
              provider.setFilter(
                estado: value == "estado" ? selected : null,
                marca: value == "marca" ? selected : null,
                area: value == "area" ? selected : null,
                litros: value == "litros" ? selected : null,
                capacidad: value == "capacidad" ? selected : null,
                peso_placa_de_datos: value == "peso_placa_de_datos" ? selected : null,
                fases: value == "fases" ? selected : null,
                field: value,
              );
              setState(() {
                currentPage = 0;
              });
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
                value: "estado", child: Text("Filtrar por Estado")),
            PopupMenuItem(
                value: "marca", child: Text("Filtrar por Marca")),
            PopupMenuItem(value: "area", child: Text("Filtrar por Área")),
            PopupMenuItem(
                value: "litros", child: Text("Filtrar por Litros")),
            PopupMenuItem(
                value: "capacidad", child: Text("Filtrar por Capacidad")),
            PopupMenuItem(
                value: "peso_placa_de_datos", child: Text("Filtrar por Peso de Placa de Datos")),
            PopupMenuItem(
                value: "fases", child: Text("Filtrar por Fases")),
            PopupMenuDivider(),
            PopupMenuItem(value: "clear", child: Text("Quitar filtro")),
          ],
        );
      },
    );
  }

  Widget _buildBody(List<Mantenimiento> mantenimientos, String selectedField) {
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
        // Mostrar filtro activo
        if (selectedField != "estado")
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
                  'Filtro activo: $selectedField',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () {
                    context.read<MantenimientoProvider>().clearFilters();
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
                  subtitleValue = "Litros: ${m.aceite}";
                  break;
                case "capacidadKVA":
                  subtitleValue = "Capacidad: ${m.capacidadKVA}";
                  break;
                case "peso_placa_de_datos":
                  subtitleValue = "Peso placa de datos: ${m.peso_placa_de_datos}";
                  break;
                case "fases":
                  subtitleValue = "Fases: ${m.fases}";
                  break;
                default:
                  subtitleValue = "Estado: ${m.estado}";
              }

              return Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 4, horizontal: 8),
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
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MantenimientoOperationsScreen(
                                mantenimiento: m),
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
              onPressed: () async {
                await exportMantenimientosToExcel(context);
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
        actions: [_buildFilterButton()],
      ),
      body: Consumer<MantenimientoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          final filteredMantenimientos = provider.filteredMantenimientos;
          return _buildBody(filteredMantenimientos, provider.selectedField);
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