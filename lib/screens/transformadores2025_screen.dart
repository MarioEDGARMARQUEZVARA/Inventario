import 'package:flutter/material.dart';
import 'package:inventario_proyecto/widgets/main_drawer.dart';
import 'package:inventario_proyecto/services/transformadores_service.dart';
import 'package:inventario_proyecto/models/tranformadoresactuales.dart';
import 'package:inventario_proyecto/screens/transformadoresactuales_operations_screen.dart';
import 'package:inventario_proyecto/screens/transformadoresactuales_add_screen.dart';

class Transformadores2025Screen extends StatefulWidget {
  const Transformadores2025Screen({super.key});

  @override
  State<Transformadores2025Screen> createState() =>
      _Transformadores2025ScreenState();
}

class _Transformadores2025ScreenState
    extends State<Transformadores2025Screen> {
  String? selectedEstado;
  String? selectedMarca;
  String? selectedArea;
  String? selectedMes;

  int? selectedAceite;
  int? selectedPeso;
  int? selectedResistencia;

  // 🔧 cambiamos a String? porque son rangos tipo "1 - 10"
  String? selectedCargas;
  String? selectedFases;
  String? selectedCapacidad;

  String selectedField = "estado"; // subtítulo por defecto

  int currentPage = 0;
  final int itemsPerPage = 6;

  Future<void> _navigateToOperations(Tranformadoresactuales t) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TransformadoresActualesOperationsScreen(transformador: t),
      ),
    );
    setState(() {}); // refresca al volver
  }

  // extrae número de string tipo "20 LTS" o "500 KGS"
  int _extraerNumero(String valor) {
    return int.tryParse(valor.replaceAll(RegExp(r'[^0-9]'), "")) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1AFF),
        title: const Text(
          'Transformadores 2025',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          FutureBuilder<List<Tranformadoresactuales>>(
            future: getTranformadoresActuales(),
            builder: (context, snapshot) {
              final transformadores = snapshot.data ?? [];
              final uniqueMeses = transformadores.map((t) => t.mes).toSet().toList();

              return PopupMenuButton<String>(
                icon: const Icon(Icons.filter_alt, color: Colors.white),
                onSelected: (value) async {
                  if (value == "clear") {
                    setState(() {
                      selectedEstado = null;
                      selectedMarca = null;
                      selectedArea = null;
                      selectedMes = null;
                      selectedAceite = null;
                      selectedPeso = null;
                      selectedCargas = null;
                      selectedFases = null;
                      selectedResistencia = null;
                      selectedCapacidad = null;
                      selectedField = "estado";
                      currentPage = 0;
                    });
                    return;
                  }

                  setState(() {
                    selectedField = value;
                  });

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
                    setState(() {
                      selectedEstado = null;
                      selectedMarca = null;
                      selectedArea = null;
                      selectedMes = null;
                      selectedAceite = null;
                      selectedPeso = null;
                      selectedCargas = null;
                      selectedFases = null;
                      selectedResistencia = null;
                      selectedCapacidad = null;

                      if (value == "estado") selectedEstado = selected;
                      if (value == "marca") selectedMarca = selected;
                      if (value == "area") selectedArea = selected;
                      if (value == "mes") selectedMes = selected;
                      if (value == "aceite") {
                        selectedAceite = _extraerNumero(selected);
                      }
                      if (value == "peso") {
                        selectedPeso = _extraerNumero(selected);
                      }
                      if (value == "cargas") {
                        selectedCargas = selected;
                      }
                      if (value == "fases") {
                        selectedFases = selected;
                      }
                      if (value == "resistencia") {
                        selectedResistencia = int.tryParse(selected);
                      }
                      if (value == "capacidad") {
                        selectedCapacidad = selected;
                      }
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
          ),
        ],
      ),
      body: FutureBuilder<List<Tranformadoresactuales>>(
        future: getTranformadoresActuales(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var transformadores = snapshot.data ?? [];

          // aplicar filtros
          if (selectedEstado != null) {
            transformadores =
                transformadores.where((t) => t.estado == selectedEstado).toList();
          }
          if (selectedMarca != null) {
            transformadores =
                transformadores.where((t) => t.marca == selectedMarca).toList();
          }
          if (selectedArea != null) {
            transformadores =
                transformadores.where((t) => t.area == selectedArea).toList();
          }
          if (selectedMes != null) {
            transformadores =
                transformadores.where((t) => t.mes == selectedMes).toList();
          }
          if (selectedAceite != null) {
            transformadores = transformadores
                .where((t) => _extraerNumero(t.aceite) == selectedAceite)
                .toList();
          }
          if (selectedPeso != null) {
            transformadores = transformadores
                .where((t) =>
                    _extraerNumero(t.peso_placa_de_datos) == selectedPeso)
                .toList();
          }

          // 🔧 FILTROS POR RANGO
          if (selectedCargas != null) {
            final parts = selectedCargas!.split("-");
            final min = int.parse(parts[0].trim());
            final max = int.parse(parts[1].trim());
            transformadores = transformadores
                .where((t) => t.cargas >= min && t.cargas <= max)
                .toList();
          }
          if (selectedFases != null) {
            final parts = selectedFases!.split("-");
            final min = int.parse(parts[0].trim());
            final max = int.parse(parts[1].trim());
            transformadores = transformadores
                .where((t) => t.fases >= min && t.fases <= max)
                .toList();
          }
          if (selectedCapacidad != null) {
            final parts = selectedCapacidad!.replaceAll("KVA", "").split("-");
            final min = int.parse(parts[0].trim());
            final max = int.parse(parts[1].trim());
            transformadores = transformadores
                .where((t) =>
                    t.capacidadKVA >= min &&
                    t.capacidadKVA <= max)
                .toList();
          }
          if (selectedResistencia != null) {
            transformadores = transformadores
                .where(
                    (t) => t.resistencia_aislamiento_megaoms == selectedResistencia)
                .toList();
          }

          if (transformadores.isEmpty) {
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
              Expanded(
                child: ListView.builder(
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
                        onTap: () {
                          // Debug: print transformador data before navigation
                          try {
                            // ignore: avoid_print
                            print('NAVIGATE transformadores2025 -> ${t.toJson()}');
                          } catch (_) {}
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
                    onPressed: () {},
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
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TransformadoresActualesAddScreen(),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
