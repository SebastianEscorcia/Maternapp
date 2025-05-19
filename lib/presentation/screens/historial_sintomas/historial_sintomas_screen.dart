import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../layout/layout_scaffold.dart';
import '../../providers/sintomas/sintoma_provider.dart';
import '../../providers/maternal_provider.dart';

class HistorialSintomasScreen extends StatelessWidget {
  const HistorialSintomasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SintomaProvider>();
    final materna = context.read<MaternaProvider>().materna;

    return LayoutScaffold(
      title: "Historial de síntomas",
      useMaternalBackground: true,
      showBack: true,
      child: FutureBuilder(
        future: provider.cargarHistorialDelMesConCache(materna!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final historial = provider.historialPorDia;

          if (historial.isEmpty) {
            return const Center(
              child: Text("No hay síntomas registrados este mes"),
            );
          }
          print("IDs del catálogo: ${provider.catalogo.map((s) => s.id)}");
          print(
              "IDs en historial: ${provider.historialPorDia.values.expand((l) => l)}");

          final Map<String, int> frecuencia = {};
          for (final sintomas in historial.values) {
            for (final id in sintomas) {
              frecuencia[id] = (frecuencia[id] ?? 0) + 1;
            }
          }

          final total = frecuencia.values.fold(0, (a, b) => a + b);

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text("Síntomas registrados por día",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center),
                ...historial.entries.map((entry) => Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        title: Text(entry.key),
                        subtitle: Text(entry.value
                            .map((id) => provider.nombreSintomaPorId(id))
                            .join(', ')),
                      ),
                    )),
                const SizedBox(height: 16),
                const Text("Estadísticas del mes",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center),
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
                          radius: 80,
                          titleStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: frecuencia.keys.map((id) {
                    final color = provider.colorSintomaPorId(id);
                    final nombre = provider.nombreSintomaPorId(id);
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 12, height: 12, color: color),
                        const SizedBox(width: 4),
                        Text(nombre, style: const TextStyle(fontSize: 12)),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  "Total de síntomas registrados: $total",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
