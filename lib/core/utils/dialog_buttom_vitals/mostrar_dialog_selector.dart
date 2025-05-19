import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../presentation/providers/maternal_provider.dart';
import '../../../presentation/providers/signal_vitals/signal_vital_provider.dart';

void mostrarSelectorSmartwatch(BuildContext context) {
  final materna = context.read<MaternaProvider>().materna;
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Selecciona tu smartwatch"),
        content:
            const Text("Elige el tipo de reloj con el que deseas conectarte."),
        actions: [
          TextButton.icon(
            onPressed: () async {
              Navigator.of(dialogContext)
                  .pop(); // Cierra el diálogo del selector

              final scaffoldContext =
                  Scaffold.maybeOf(context)?.context ?? context;

              await _mostrarDialogoConectando(context);

              final resultado = await simularConexionDispositivo();
              if (materna != null) {
                await Provider.of<SignosVitalesProvider>(context, listen: false)
                    .actualizarSignos(materna.uid);
              }
              debugPrint("Resultado conexión smartwatch: $resultado");

              ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                SnackBar(
                  content: Text(resultado),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 1),
                ),
              );
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
            const Text("Conectando dispositivo...",
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ),
  );
  await Future.delayed(const Duration(seconds: 1));
  Navigator.of(context).pop(); // Cierra el diálogo de carga
}

Future<String> simularConexionDispositivo() async {
  await Future.delayed(const Duration(seconds: 1));
  return "Dispositivo Wear OS conectado correctamente";
}
