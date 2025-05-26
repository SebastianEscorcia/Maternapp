import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../providers/sintomas/sintoma_provider.dart';

class HistorialSintomasFamiliarWidget extends StatelessWidget {
  const HistorialSintomasFamiliarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SintomaProvider>();
    final historial = provider.historialPorDia;

    if (historial.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("No hay síntomas registrados este mes"),
      );
    }

    final Map<String, int> frecuencia = {};
    for (final sintomas in historial.values) {
      for (final id in sintomas) {
        frecuencia[id] = (frecuencia[id] ?? 0) + 1;
      }
    }

    final total = frecuencia.values.fold(0, (a, b) => a + b);
    final historialOrdenado = historial.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Historial reciente",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink,),
        ),
        ...historialOrdenado.map(
          (entry) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
            child: ListTile(
              title: Text(entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(entry.value
                  .map((id) => provider.nombreSintomaPorId(id))
                  .join(', ')),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Distribución de síntomas",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink,),
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1.3,
          child: PieChart(
            PieChartData(
              sections: frecuencia.entries.map((entry) {
                final porcentaje = (entry.value / total) * 100;
                return PieChartSectionData(
                  value: entry.value.toDouble(),
                  title: "${porcentaje.toStringAsFixed(1)}%",
                  color: provider.colorSintomaPorId(entry.key),
                  radius: 70,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: frecuencia.keys.map((id) {
            final color = provider.colorSintomaPorId(id);
            final nombre = provider.nombreSintomaPorId(id);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withAlpha(1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 12, height: 12, color: color),
                  const SizedBox(width: 6),
                  Text(nombre, style: const TextStyle(fontSize: 12)),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
