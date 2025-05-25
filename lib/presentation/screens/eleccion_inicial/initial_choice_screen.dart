import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../layout/layout_scaffold.dart';

class InitialChoiceScreen extends StatelessWidget {
  const InitialChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutScaffold(
      title: "¡Bienvenid@! 🌸",
      useMaternalBackground: true,
      centerContent: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/family1.json',
            width: 200,
            repeat: true,
          ),
          const SizedBox(height: 16),
          const Text(
            "¿Cómo deseas usar MaternApp?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/welcome');
            },
            icon: const Icon(Icons.pregnant_woman),
            label: const Text("MaternApp para mí"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/welcomeFamiliar');
            },
            icon: const Icon(Icons.family_restroom),
            label: const Text("Tengo un código de pareja/familiar"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[300],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
