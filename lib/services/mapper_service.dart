// lib/services/mapper_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Normaliza los datos de transformadores/mantenimiento
/// según el destino de la colección.
Map<String, dynamic> normalizarDatos(
    Map<String, dynamic> data, String destino) {
  
  // Campos comunes
  String nombre = data["Nombre"] ?? "";
  int capacidad = data["Capacidad"] ?? 0;
  int peso = data["Peso"] ?? 0;


  
  String zona = data["Zona"] ?? data["Area"] ?? "";
  String litros = data["Litros"] ?? data["Aceite"] ?? "";

  switch (destino) {
    case "transformadores2025":
      return {
        "Nombre": nombre,
        "Capacidad": capacidad,
        "Aceite": litros,
        "Peso": peso,
        "Zona": zona,
        "Estado": "reparado",
        "FechaReparacion": Timestamp.now(),
      };

    case "Transformadoresxzona":
      return {
        "Nombre": nombre,
        "Capacidad": capacidad,
        "Litros": litros,
        "Peso": peso,
        "Zona": zona,
        "Estado": "reparado",
        "FechaReparacion": Timestamp.now(),
      };

    case "Mantenimiento":
      return {
        "Nombre": nombre,
        "Capacidad": capacidad,
        "Litros": litros,
        "Peso": peso,
        "Zona": zona,
        "Motivo": data["Motivos"] ?? "",
        "FechaEnvio": Timestamp.now(),
        "Estado": "Mantenimiento",
      };

    default:
      return data; // fallback
  }
}
