import 'package:flutter/material.dart';

import '../../screens/sintomas/registrar_sintomas_screen.dart';



class RegistrarSintomaButton extends StatelessWidget {
  const RegistrarSintomaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SeleccionarSintomasScreen()),
        );
      },
      icon: const Icon(Icons.add_reaction_outlined),
      label: const Text("Registrar síntoma"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink[300],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
