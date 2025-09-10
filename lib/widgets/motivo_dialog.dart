import 'package:flutter/material.dart';

Future<String?> mostrarMotivoDialog(BuildContext context) async {
  final motivoController = TextEditingController();
  bool habilitar = false;

  return showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Motivo'),
          content: TextField(
            controller: motivoController,
            decoration: const InputDecoration(hintText: 'Escribe el motivo'),
            autofocus: true,
            onChanged: (value) => setState(() => habilitar = value.isNotEmpty),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: habilitar
                  ? () => Navigator.pop(context, motivoController.text)
                  : null,
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    },
  );
}
