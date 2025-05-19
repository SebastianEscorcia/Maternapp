import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Routes/routes.dart';
import '../../providers/sintomas/sintoma_provider.dart';
import '../../screens/historial_sintomas/historial_sintomas_screen.dart';

class HistorialSintomasButton extends StatelessWidget {
  const HistorialSintomasButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.pink.shade50, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: ListTile(
        leading: const Icon(Icons.bar_chart, color: Colors.deepPurple),
        title: const Text("Historial de síntomas"),
        subtitle: const Text("Ver días y frecuencia de tus síntomas"),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const HistorialSintomasScreen(), 
              settings: const RouteSettings(name: Routes.historialSintomasScreen),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 400),
            ),
          ).then((_){
            final provider = context.read<SintomaProvider>();  
            provider.limpiarCacheHistorial();
          });
        },
      ),
    );
  }
}
