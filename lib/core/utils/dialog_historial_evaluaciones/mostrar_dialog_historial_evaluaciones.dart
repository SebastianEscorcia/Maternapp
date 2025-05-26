import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future<void> mostrarDialogoGenerandoPDF(BuildContext context) async {
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
            // Asegúrate de tener este archivo en assets/animations
            // Y declarado en pubspec.yaml
            SizedBox(
              width: 120,
              child: Lottie.asset(
                'assets/animations/loading_heart.json',
                repeat: true,
              ),
            ),
            const SizedBox(height: 12),
            const Text("Espere un momento...", style: TextStyle(fontSize: 16)),
            const Text("Procesando documento",
                style: TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
      ),
    ),
  );
}
