import 'package:flutter/material.dart';

void mostrarSelectorSmartwatch(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Selecciona tu smartwatch"),
        content: const Text(
          "Elige el tipo de reloj con el que deseas conectarte.",
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
              Navigator.pushNamed(context, '/selectWearDevice'); // Ir a selector Wear OS
            },
            icon: const Icon(Icons.watch),
            label: const Text("Wear OS"),
          ),
          TextButton.icon(
            onPressed: () {
              // TODO: Lógica para Huawei Band
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Huawei no implementado aún")),
              );
            },
            icon: const Icon(Icons.watch_outlined),
            label: const Text("Huawei"),
          ),
        ],
      );
    },
  );
}
