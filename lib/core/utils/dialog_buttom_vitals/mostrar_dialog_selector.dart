import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../presentation/providers/maternal_provider.dart';
import '../../../presentation/providers/signal_vitals/signal_vital_provider.dart';
import 'evaluador_signos.dart';

void mostrarSelectorSmartwatch(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Selecciona tu smartwatch"),
        content: const Text("Elige el tipo de reloj con el que deseas conectarte."),
        actions: [
          TextButton.icon(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              final scaffoldContext = Scaffold.maybeOf(context)?.context ?? context;

              await _mostrarDialogoConectando(context);

              try {
                final materna = context.read<MaternaProvider>().materna;
                final provider = context.read<SignosVitalesProvider>();

                if (materna != null) {
                  await provider.actualizarSignos(materna.uid, esMaterna: true);

                  final signos = provider.signos!;
                  final evaluador = EvaluadorSignosVitales(esMaterna: true);

                  final resultados = [
                    {
                      'label': 'Frecuencia Cardíaca',
                      'valor': '${signos.frecuenciaCardiaca} bpm',
                      'estado': evaluador.evaluarFrecuenciaCardiaca(
                        double.tryParse(signos.frecuenciaCardiaca) ?? 0,
                      ),
                      'icon': Icons.favorite,
                    },
                    {
                      'label': 'Oxigenación',
                      'valor': '${signos.oxigenacion} %',
                      'estado': evaluador.evaluarOxigenacion(
                        double.tryParse(signos.oxigenacion) ?? 0,
                      ),
                      'icon': Icons.bubble_chart,
                    },
                    {
                      'label': 'Temperatura',
                      'valor': '${signos.temperatura.toStringAsFixed(1)} °C',
                      'estado': evaluador.evaluarTemperatura(signos.temperatura),
                      'icon': Icons.thermostat,
                    },
                  ];

                  Color colorEstado(String estado) {
                    if (estado.contains("normal")) return Colors.green;
                    if (estado.contains("alta") || estado.contains("baja")) return Colors.amber;
                    return Colors.redAccent;
                  }

                  await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: const Text("🩺 Evaluación de signos vitales"),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: resultados.map((res) {
                            final estado = res['estado'] as String;
                            final color = colorEstado(estado);

                            return Card(
                              color: color.withAlpha(1),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: Icon(res['icon'] as IconData, color: color),
                                title: Text(
                                  res['label'] as String,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                                ),
                                subtitle: Text(estado, style: TextStyle(color: color)),
                                trailing: Text(
                                  res['valor'] as String,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cerrar"),
                        ),
                      ],
                    ),
                  );

                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(
                      content: Text("Dispositivo Wear OS conectado correctamente"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                final mensaje = e.toString().contains("Smartwatch")
                    ? "❌ No se pudo conectar con el smartwatch. Asegúrate de que esté encendido y vinculado."
                    : "⚠️ Ocurrió un error inesperado";

                ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                  SnackBar(
                    content: Text(mensaje),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.redAccent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            icon: const Icon(Icons.watch),
            label: const Text("Smartwatch Wear OS"),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Huawei no implementado aún"),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 1),
                ),
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

Future<void> _mostrarDialogoConectando(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/loading_heart.json',
              width: 120,
            ),
            const SizedBox(height: 10),
            const Text("Conectando dispositivo...", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ),
  );
  await Future.delayed(const Duration(seconds: 1));
  Navigator.of(context).pop(); // Cierra el diálogo de carga
}
