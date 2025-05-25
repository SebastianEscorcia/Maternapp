import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';


import '../../layout/layout_scaffold.dart';
import '../../providers/familiar/familiar_provider.dart';
import '../../widgets/texts/app_text.dart';

class HomeFamiliarScreen extends StatelessWidget {
  const HomeFamiliarScreen({super.key});

  Future<bool> _cargarFamiliar(BuildContext context) async {
    final provider = Provider.of<FamiliarProvider>(context, listen: false);
    if (provider.familiar == null) {
      await provider.cargarFamiliarDesdePrefs();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _cargarFamiliar(context),
      builder: (context, snapshot) {
        final familiar = context.watch<FamiliarProvider>().familiar;

        if (snapshot.connectionState != ConnectionState.done || familiar == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        return LayoutScaffold(
          useMaternalBackground: true,
          centerContent: true,
          title: "Tu espacio familiar 👪",
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animación
              SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  'assets/animations/family2.json',
                  repeat: true,
                ),
              ),
              const SizedBox(height: 30),

              AppText(
                text: "¡Hola ${familiar.nombre}!",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                align: TextAlign.center,
                color: Colors.pink,
              ),
              const SizedBox(height: 12),
              const AppText(
                text: "Gracias por acompañar a tu ser querido en este hermoso viaje 💕",
                fontSize: 16,
                align: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
