import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../presentation/layout/layout_scaffold.dart';
import '../../providers/codigoVinculacion/codigo_vinculacion_provider.dart';
import '../../providers/maternal_provider.dart';

class VincularFamiliarScreen extends StatelessWidget {
  const VincularFamiliarScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final materna = context.read<MaternaProvider>().materna;
    final codigoProvider = context.watch<CodigoVinculacionProvider>();
    if (materna?.uid != null &&
        codigoProvider.codigoGenerado == null &&
        !codigoProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        codigoProvider.generarCodigo(materna!.uid);
      });
    }

    return LayoutScaffold(
      title: "Vincular Familiar",
      useMaternalBackground: true,
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Comparte este código con tu familiar 🥰",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          if (materna?.uid != null) ...[
            if (codigoProvider.isLoading) ...[
              const Center(child: CircularProgressIndicator()),
            ] else if (codigoProvider.codigoGenerado != null) ...[
              Center(
                child: QrImageView(
                  data: codigoProvider.codigoGenerado!,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 20),
              SelectableText(
                codigoProvider.codigoGenerado!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () async {
                  await codigoProvider.generarCodigo(materna!.uid);
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Regenerar código"),
              ),
              const SizedBox(height: 20),
              const Text(
                "Tu familiar podrá escanear el código o ingresarlo manualmente en su aplicación",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ] else if (codigoProvider.error != null) ...[
              const SizedBox(height: 20),
              Text(
                codigoProvider.error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ] else ...[
            const Text(
              "No se pudo obtener tu código. Asegúrate de estar registrada correctamente.",
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
