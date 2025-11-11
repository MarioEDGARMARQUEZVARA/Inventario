import 'package:flutter/material.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';
import 'package:inventario_proyecto/services/transformadores_service.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';
import 'package:inventario_proyecto/screens/transformadoresactuales_operations_screen.dart';
import 'package:inventario_proyecto/screens/transformadoresactuales_add_screen.dart';
import 'package:provider/provider.dart';
import '../providers/transformadores2025_provider.dart';
import '../providers/session_provider.dart';
import '../widgets/inactivity_detector.dart';

class Transformadores2025Screen extends StatefulWidget {
  const Transformadores2025Screen({super.key});

  @override
  State<Transformadores2025Screen> createState() =>
      _Transformadores2025ScreenState();
}

class _Transformadores2025ScreenState
    extends State<Transformadores2025Screen> {
  int currentPage = 0;
  final int itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<Transformadores2025Provider>();
      provider.fetchTransformadores();
      
      // SOLO resetear timer, NO iniciar sesión
      final sessionProvider = context.read<SessionProvider>();
      sessionProvider.resetTimer();
    });
  }

  Future<void> _navigateToOperations(Tranformadoresactuales t) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TransformadoresActualesOperationsScreen(transformador: t),
      ),
    );
    // El provider se actualizará automáticamente a través de los listeners
  }

  Widget _buildFilterButton() {
    final sessionProvider = Provider.of<SessionProvider>(context);
    
    return Consumer<Transformadores2025Provider>(
      builder: (context, provider, child) {
        final transformadores = provider.transformadores;
        final uniqueMeses = transformadores.map((t) => t.mes).toSet().toList();

        return PopupMenuButton<String>(
          icon: const Icon(Icons.filter_alt, color: Colors.white),
          onSelected: sessionProvider.showTimeoutDialog 
              ? null 
              : (value) async {
                  if (value == "clear") {
                    provider.clearFilters();
                    setState(() {
                      currentPage = 0;
                    });
                    return;
                  }

                  List<String> values = [];
                  if (value == "estado" ||
                      value == "marca" ||
                      value == "area" ||
                      value == "mes") {
                    if (value == "mes") {
                      values = uniqueMeses;
                    } else {
                      values = transformadores
                          .map((t) => value == "estado"
                              ? t.estado
                              : value == "marca"
                                  ? t.marca
                                  : t.area)
                          .toSet()
                          .toList();
                    }
                  } else {
                    if (value == "aceite") {
                      values = List.generate(10, (i) => "${(i + 1) * 10} LTS");
                    } else if (value == "peso") {
                      values = List.generate(10, (i) => "${(i + 1) * 100} KGS");
                    } else if (value == "cargas") {
                      values = List.generate(10, (i) => "${i * 10 + 1} - ${(i + 1) * 10}");
                    } else if (value == "fases") {
                      values = List.generate(10, (i) => "${i * 10 + 1} - ${(i + 1) * 10}");
                    } else if (value == "resistencia") {
                      values = List.generate(10, (i) => "${(i + 1) * 10}");
                    } else if (value == "capacidad") {
                      values = List.generate(10, (i) => "${i * 10 + 1} - ${(i + 1) * 10} KVA");
                    }
                  }

                  final selected = await showDialog<String>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text("Selecciona $value"),
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
                    final newFilter = _mapFilterValue(value, selected);
                    provider.setFilter(
                      estado: value == "estado" ? selected : null,
                      marca: value == "marca" ? selected : null,
                      area: value == "area" ? selected : null,
                      mes: value == "mes" ? selected : null,
                      aceite: value == "aceite" ? _extraerNumero(selected) : null,
                      peso: value == "peso" ? _extraerNumero(selected) : null,
                      cargas: value == "cargas" ? selected : null,
                      fases: value == "fases" ? selected : null,
                      resistencia: value == "resistencia" ? int.tryParse(selected) : null,
                      capacidad: value == "capacidad" ? selected : null,
                      field: value,
                    );
                    setState(() {
                      currentPage = 0;
                    });
                  }
                },
          itemBuilder: (context) => const [
            PopupMenuItem(value: "estado", child: Text("Por Estado")),
            PopupMenuItem(value: "marca", child: Text("Por Marca")),
            PopupMenuItem(value: "area", child: Text("Por Área")),
            PopupMenuItem(value: "mes", child: Text("Por Mes")),
            PopupMenuItem(value: "aceite", child: Text("Por Aceite (LTS)")),
            PopupMenuItem(value: "peso", child: Text("Por Peso (KGS)")),
            PopupMenuItem(value: "cargas", child: Text("Por Cargas")),
            PopupMenuItem(value: "fases", child: Text("Por Fases")),
            PopupMenuItem(value: "resistencia", child: Text("Por Resistencia (MΩ)")),
            PopupMenuItem(value: "capacidad", child: Text("Por Capacidad (KVA)")),
            PopupMenuDivider(),
            PopupMenuItem(value: "clear", child: Text("Quitar filtro")),
          ],
        );
      },
    );
  }

  String _mapFilterValue(String filterType, String value) {
    // Mapea el valor seleccionado al formato esperado por el provider
    return value;
  }

  int _extraerNumero(String valor) {
    return int.tryParse(valor.replaceAll(RegExp(r'[^0-9]'), "")) ?? 0;
  }

  Widget _buildBody(List<Tranformadoresactuales> transformadores, String selectedField) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    
    if (transformadores.isEmpty && !sessionProvider.showTimeoutDialog) {
      return const Center(
          child: Text('No hay transformadores registrados.'));
    }

    // paginación
    final totalPages = (transformadores.length / itemsPerPage).ceil();
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage > transformadores.length)
        ? transformadores.length
        : startIndex + itemsPerPage;
    final pageItems = transformadores.sublist(startIndex, endIndex);

    return Column(
      children: [
        // Mostrar filtro activo
        if (selectedField != "estado" && !sessionProvider.showTimeoutDialog)
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
                  onPressed: sessionProvider.showTimeoutDialog 
                      ? null 
                      : () {
                          context.read<Transformadores2025Provider>().clearFilters();
                          setState(() {
                            currentPage = 0;
                          });
                        },
                ),
              ],
            ),
          ),
        Expanded(
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
              : ListView.builder(
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) {
                    final t = pageItems[index];

                    String subtitleValue = "";
                    switch (selectedField) {
                      case "marca":
                        subtitleValue = "Marca: ${t.marca}";
                        break;
                      case "area":
                        subtitleValue = "Área: ${t.area}";
                        break;
                      case "mes":
                        subtitleValue = "Mes: ${t.mes}";
                        break;
                      case "aceite":
                        subtitleValue = "Aceite: ${t.aceite}";
                        break;
                      case "peso":
                        subtitleValue = "Peso: ${t.peso_placa_de_datos}";
                        break;
                      case "cargas":
                        subtitleValue = "Cargas: ${t.cargas}";
                        break;
                      case "fases":
                        subtitleValue = "Fases: ${t.fases}";
                        break;
                      case "resistencia":
                        subtitleValue = "Resistencia: ${t.resistencia_aislamiento_megaoms} MΩ";
                        break;
                      case "capacidad":
                        subtitleValue = "Capacidad: ${t.capacidadKVA} KVA";
                        break;
                      default:
                        subtitleValue = "Estado: ${t.estado}";
                    }

                    return Container(
                      margin:
                          const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          "TRANSFORMADOR ${t.consecutivo}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          subtitleValue,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14),
                        ),
                        // AGREGAR ICONO DE HERRAMIENTA AZUL SI FUE ENVIADO A MANTENIMIENTO
                        trailing: t.enviadoMantenimiento 
                            ? const Icon(Icons.build, color: Colors.blue, size: 24)
                            : null,
                        onTap: sessionProvider.showTimeoutDialog 
                            ? null 
                            : () {
                                _navigateToOperations(t);
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
              onPressed: sessionProvider.showTimeoutDialog 
                  ? null 
                  : () async {
                      exportTransformadoresToExcel(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: sessionProvider.showTimeoutDialog 
                    ? Colors.grey 
                    : Colors.green,
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
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(bottom: 80.0), // Espacio para el FAB
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: currentPage > 0 && !sessionProvider.showTimeoutDialog
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
                onPressed: currentPage < totalPages - 1 && !sessionProvider.showTimeoutDialog
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
    final sessionProvider = Provider.of<SessionProvider>(context);

    return InactivityDetector(
      child: Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          backgroundColor: sessionProvider.showTimeoutDialog 
              ? Colors.orange 
              : const Color(0xFF2A1AFF),
          title: const Text(
            'Transformadores 2025',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          actions: [_buildFilterButton()],
        ),
        body: Consumer<Transformadores2025Provider>(
          builder: (context, provider, child) {
            if (provider.isLoading && !sessionProvider.showTimeoutDialog) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.errorMessage != null && !sessionProvider.showTimeoutDialog) {
              return Center(child: Text(provider.errorMessage!));
            }

            final filteredTransformadores = provider.filteredTransformadores;
            return _buildBody(filteredTransformadores, provider.selectedField);
          },
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
            : Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFF2196F3),
                  onPressed: sessionProvider.showTimeoutDialog 
                      ? null 
                      : () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TransformadoresActualesAddScreen(),
                            ),
                          );
                        },
                  child: const Icon(Icons.add, size: 32),
                ),
              ),
      ),
    );
  }
}