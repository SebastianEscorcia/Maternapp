import 'package:flutter/material.dart';

void mostrarAlerta(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      duration: const Duration(microseconds: 1000000),
    ),
  );
}
