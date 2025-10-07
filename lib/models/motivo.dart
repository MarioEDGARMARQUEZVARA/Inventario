import 'package:cloud_firestore/cloud_firestore.dart';

class Motivo {
  String? id;
  String descripcion;
  DateTime? fecha;

  Motivo({
    this.id,
    required this.descripcion,
    required this.fecha,
  });

  factory Motivo.fromMap(Map<String, dynamic> map, {String? id}) {
    return Motivo(
      id: id,
      descripcion: map['Descripcion'] ?? '',
      fecha: map['fecha'] != null
          ? (map['fecha'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Descripcion': descripcion,
      'Fecha': fecha,
    };
  }
}
