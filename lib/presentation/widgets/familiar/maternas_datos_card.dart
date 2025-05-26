import 'package:flutter/material.dart';
class MaternaDatosCard extends StatelessWidget {
  final String nombre;
  final int semanasGestacion;
  final String fechaPartoFormatted;

  const MaternaDatosCard({
    super.key,
    required this.nombre,
    required this.semanasGestacion,
    required this.fechaPartoFormatted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pink.shade50, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.shade300.withAlpha(100),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nombre: $nombre", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Text("Semanas de embarazo: $semanasGestacion",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Text("Fecha estimada de parto: $fechaPartoFormatted",
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}