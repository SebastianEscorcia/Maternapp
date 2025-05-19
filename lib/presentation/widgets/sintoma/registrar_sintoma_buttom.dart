import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/sintomas/registrar_sintomas_screen.dart';
import '../../providers/maternal_provider.dart';
import '../../providers/sintomas/sintoma_provider.dart';

class RegistrarSintomaButton extends StatelessWidget {
  const RegistrarSintomaButton({super.key});

  @override
  Widget build(BuildContext context) {
    final materna = context.read<MaternaProvider>().materna;

    if (materna == null) return const SizedBox.shrink();

    final sintomaProvider = context.read<SintomaProvider>();

    // Usar una variable para controlar si ya cargó
    return FutureBuilder(
      future: Future.microtask(() => sintomaProvider.cargarSintomasDeHoy(materna.uid)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 48,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Consumer<SintomaProvider>(
          builder: (context, provider, _) {
            final yaRegistrado = provider.registroHoy?.sintomasIds.isNotEmpty ?? false;

            return ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SeleccionarSintomasScreen(),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              },
              icon: Icon(
                yaRegistrado ? Icons.edit_note : Icons.add_reaction_outlined,
              ),
              label: Text(yaRegistrado ? "Editar síntomas de hoy" : "Registrar síntoma"),
              style: ElevatedButton.styleFrom(
                backgroundColor: yaRegistrado ? Colors.deepPurple : Colors.pink[300],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            );
          },
        );
      },
    );
  }
}

