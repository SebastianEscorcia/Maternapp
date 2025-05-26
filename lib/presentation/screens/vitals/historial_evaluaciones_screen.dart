import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';


import '../../../domain/services/pdf/evaluacion_pdf_helper.dart';
import '../../layout/layout_scaffold.dart';
import '../../providers/maternal_provider.dart';
import '../../providers/signal_vitals/signal_vital_provider.dart';

class HistorialEvaluacionesScreen extends StatelessWidget {
  const HistorialEvaluacionesScreen({super.key});

  Color colorEstado(String estado) {
    if (estado.contains("normal")) return Colors.green;
    if (estado.contains("alta") || estado.contains("baja")) return Colors.amber;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignosVitalesProvider>();
    final historialPorMes = provider.agruparEvaluacionesPorMes();
    final materna = context.read<MaternaProvider>().materna;

    return LayoutScaffold(
      title: "Evaluaciones clínicas",
      showBack: true,
      useMaternalBackground: true,
      bottomNav: Padding(
        padding: const EdgeInsets.all(12),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final nombre = "${materna?.nombre} ";
            final data = provider.historialEvaluaciones;

            await EvaluacionPdfHelper.mostrarDialogoGenerandoPDF(context);
            try {
              await EvaluacionPdfHelper.compartirPdfEvaluaciones(
                context,
                data,
                nombreMaterna: nombre,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("PDF de $nombre compartido exitosamente"),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Error al compartir el PDF"),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 2),
                ),
              );
            } finally {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          backgroundColor: Colors.pink[300],
          foregroundColor: Colors.white,
          label: const Text("Compartir con médico/familiar/pareja"),
          icon: const Icon(Icons.share),
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () async {
                final data = provider.historialEvaluaciones;
                final nombre = "${materna?.nombre} ";

                await EvaluacionPdfHelper.mostrarDialogoGenerandoPDF(context);
                try {
                  await EvaluacionPdfHelper.generarPdfEvaluaciones(
                    context,
                    data,
                    nombreMaterna: nombre,
                  );
                } finally {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Exportar PDF"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[300],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: historialPorMes.isEmpty
                ? const Center(child: Text("No hay evaluaciones registradas"))
                : ListView(
                    children: historialPorMes.entries.map((mes) {
                      final mesLabel = _formatearMes(mes.key);
                      return ExpansionTile(
                        title: Text("📅 $mesLabel",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        children: mes.value.map((item) {
                          final evaluaciones =
                              item['evaluaciones'] as Map<String, String>;
                          final fecha = item['fecha'];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: ExpansionTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              title: Text("🗓 $fecha",
                                  style: const TextStyle(fontSize: 14)),
                              children: [
                                _buildFila(
                                  icon: Iconsax.heart,
                                  label: "Frecuencia cardíaca",
                                  valor: "${item['frecuenciaCardiaca']} bpm",
                                  estado:
                                      evaluaciones['frecuenciaCardiaca'] ?? '',
                                ),
                                _buildFila(
                                  icon: Iconsax.activity,
                                  label: "Oxigenación",
                                  valor: "${item['oxigenacion']} %",
                                  estado: evaluaciones['oxigenacion'] ?? '',
                                ),
                                _buildFila(
                                  icon: Icons.thermostat,
                                  label: "Temperatura",
                                  valor: "${item['temperatura']} °C",
                                  estado: evaluaciones['temperatura'] ?? '',
                                ),
                                const SizedBox(height: 6),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatearMes(String yyyyMM) {
    final partes = yyyyMM.split('-');
    final anio = partes[0];
    final mes = int.tryParse(partes[1]) ?? 1;
    const nombres = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return "${nombres[mes - 1]} $anio";
  }

  Widget _buildFila({
    required IconData icon,
    required String label,
    required String valor,
    required String estado,
  }) {
    final color = colorEstado(estado);

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label,
          style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      subtitle: Text(estado, style: TextStyle(color: color)),
      trailing: Text(valor,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: color)),
    );
  }
}
