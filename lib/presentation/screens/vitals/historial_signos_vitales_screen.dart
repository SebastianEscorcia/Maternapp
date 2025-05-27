import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../data/models/signal_vital/signal_vital_model.dart';
import '../../layout/layout_scaffold.dart';
import '../../providers/signal_vitals/signal_vital_provider.dart';
import '../../providers/maternal_provider.dart';

class HistorialSignosVitalesScreen extends StatelessWidget {
  const HistorialSignosVitalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final materna = context.read<MaternaProvider>().materna;
    final provider = Provider.of<SignosVitalesProvider>(context, listen: false);
    final future = provider.cargarHistorialFirebase(materna!.uid);
    return LayoutScaffold(
      title: "Historial de signos vitales",
      useMaternalBackground: true,
      showBack: true,
      bottomNav: null,
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final historial = provider.historial;

          if (historial.isEmpty) {
            return const Center(child: Text("No hay historial disponible"));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: Text(
                    "📊 Resumen de signos vitales",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                _buildResumenEstadistico(historial),
                const SizedBox(height: 16),
                if (_hayValores(historial, (s) => s.frecuenciaCardiaca))
                  _buildChartSection(
                    title: "Frecuencia Cardíaca (bpm)",
                    historial: historial,
                    extractor: (s) =>
                        double.tryParse(s.frecuenciaCardiaca) ?? 0,
                    color: Colors.red,
                  ),
                if (_hayValores(historial, (s) => s.oxigenacion))
                  _buildChartSection(
                    title: "Oxigenación (%)",
                    historial: historial,
                    extractor: (s) => double.tryParse(s.oxigenacion) ?? 0,
                    color: Colors.blue,
                  ),
                if (_hayValores(historial, (s) => s.temperatura.toString()))
                  _buildChartSection(
                    title: "Temperatura (°C)",
                    historial: historial,
                    extractor: (s) => s.temperatura,
                    color: Colors.orange,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _hayValores(
    List<SignosVitales> historial,
    String Function(SignosVitales) campo,
  ) {
    return historial.any((s) {
      final valor = double.tryParse(campo(s));
      return valor != null && valor > 0;
    });
  }

  /* Widget _buildResumenEstadistico(List<SignosVitales> historial) {
    double calcularPromedio(List<double> valores) =>
        valores.isEmpty ? 0 : valores.reduce((a, b) => a + b) / valores.length;

    List<double> filtrarCampo(String Function(SignosVitales) campo) =>
        historial.map((s) => double.tryParse(campo(s)) ?? 0).where((v) => v > 0).toList();

    final fc = filtrarCampo((s) => s.frecuenciaCardiaca);
    final ox = filtrarCampo((s) => s.oxigenacion);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCardResumen(
                icon: Icons.favorite,
                color: Colors.red,
                label: "FC Promedio",
                valor: "${calcularPromedio(fc).toStringAsFixed(1)} bpm",
              ),
              _buildCardResumen(
                icon: Icons.bubble_chart,
                color: Colors.blue,
                label: "Ox Promedio",
                valor: "${calcularPromedio(ox).toStringAsFixed(1)} %",
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCardResumen(
                icon: Icons.trending_up,
                color: Colors.red,
                label: "FC Máx.",
                valor: fc.isNotEmpty ? "${fc.reduce((a, b) => a > b ? a : b).toStringAsFixed(0)} bpm" : "--",
              ),
              _buildCardResumen(
                icon: Icons.trending_down,
                color: Colors.red,
                label: "FC Mín.",
                valor: fc.isNotEmpty ? "${fc.reduce((a, b) => a < b ? a : b).toStringAsFixed(0)} bpm" : "--",
              ),
            ],
          ),
        ],
      ),
    );
  } */
  // carrusel horizontal
  Widget _buildResumenEstadistico(List<SignosVitales> historial) {
    double calcularPromedio(List<double> valores) =>
        valores.isEmpty ? 0 : valores.reduce((a, b) => a + b) / valores.length;

    List<double> filtrarCampo(String Function(SignosVitales) campo) => historial
        .map((s) => double.tryParse(campo(s)) ?? 0)
        .where((v) => v > 0)
        .toList();

    final fc = filtrarCampo((s) => s.frecuenciaCardiaca);
    final ox = filtrarCampo((s) => s.oxigenacion);

    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildCardResumen(
            icon: Icons.favorite,
            color: Colors.red,
            label: "FC Promedio",
            valor: "${calcularPromedio(fc).toStringAsFixed(1)} bpm",
          ),
          _buildCardResumen(
            icon: Icons.trending_up,
            color: Colors.red,
            label: "FC Máx.",
            valor: fc.isNotEmpty
                ? "${fc.reduce((a, b) => a > b ? a : b).toStringAsFixed(0)} bpm"
                : "--",
          ),
          _buildCardResumen(
            icon: Icons.trending_down,
            color: Colors.red,
            label: "FC Mín.",
            valor: fc.isNotEmpty
                ? "${fc.reduce((a, b) => a < b ? a : b).toStringAsFixed(0)} bpm"
                : "--",
          ),
          _buildCardResumen(
            icon: Icons.bubble_chart,
            color: Colors.blue,
            label: "Ox Promedio",
            valor: "${calcularPromedio(ox).toStringAsFixed(1)} %",
          ),
          _buildCardResumen(
            icon: Icons.trending_up,
            color: Colors.blue,
            label: "Ox Máx.",
            valor: ox.isNotEmpty
                ? "${ox.reduce((a, b) => a > b ? a : b).toStringAsFixed(0)} %"
                : "--",
          ),
          _buildCardResumen(
            icon: Icons.trending_down,
            color: Colors.blue,
            label: "Ox Mín.",
            valor: ox.isNotEmpty
                ? "${ox.reduce((a, b) => a < b ? a : b).toStringAsFixed(0)} %"
                : "--",
          ),
        ],
      ),
    );
  }

  Widget _buildCardResumen({
    required IconData icon,
    required Color color,
    required String label,
    required String valor,
  }) {
    return Card(
      color: color.withAlpha(1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 4),
            Text(
              valor,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection({
    required String title,
    required List<SignosVitales> historial,
    required double Function(SignosVitales) extractor,
    required Color color,
  }) {
    final data = historial.reversed.toList();
    final labels =
        data.map((s) => DateFormat('dd/MM').format(s.fecha)).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                minY: 0,
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 20,
                      getTitlesWidget: (value, _) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();
                        if (index >= 0 && index < labels.length) {
                          return Text(
                            labels[index],
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      data.length,
                      (index) =>
                          FlSpot(index.toDouble(), extractor(data[index])),
                    ),
                    isCurved: true,
                    color: color,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                    barWidth: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
