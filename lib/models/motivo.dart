import 'package:cloud_firestore/cloud_firestore.dart';

class Motivo {
  String? id;
  String descripcion;
  DateTime? fecha;

  Motivo({this.id, required this.descripcion, this.fecha});

  factory Motivo.fromMap(Map<String, dynamic> map, {String? id}) {
    final descripcion = (map['Descripcion'] ??
            map['descripcion'] ??
            map['motivo'] ??
            map['Motivo'] ??
            '')
        .toString();

    dynamic rawFecha = map['fecha'] ?? map['Fecha'] ?? map['date'] ?? map['Fecha_motivo'];

    DateTime? fecha;
    if (rawFecha != null) {
      if (rawFecha is Timestamp) {
        fecha = rawFecha.toDate();
      } else if (rawFecha is DateTime) {
        fecha = rawFecha;
      } else if (rawFecha is int) {
        // epoch milliseconds
        try {
          fecha = DateTime.fromMillisecondsSinceEpoch(rawFecha);
        } catch (_) {}
      } else if (rawFecha is String) {
        fecha = DateTime.tryParse(rawFecha);
        if (fecha == null) {
          final partes = rawFecha.split('/');
          if (partes.length == 3) {
            final d = int.tryParse(partes[0]);
            final m = int.tryParse(partes[1]);
            final y = int.tryParse(partes[2]);
            if (d != null && m != null && y != null) fecha = DateTime(y, m, d);
          }
        }
      }
    }

    return Motivo(id: id, descripcion: descripcion, fecha: fecha);
  }

  Map<String, dynamic> toJson() {
    return {
      'Descripcion': descripcion,
      'fecha': fecha,
    };
  }
}
