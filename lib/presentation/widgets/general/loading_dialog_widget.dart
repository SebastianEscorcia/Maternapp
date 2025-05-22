import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingDialogWidget extends StatelessWidget {
  final String mensaje;

  const LoadingDialogWidget({
    super.key,
    this.mensaje = "Cargando...",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/loading_heart.json', 
              width: 120,
              height: 120,
              repeat: true,
            ),
            const SizedBox(height: 16),
            Text(
              mensaje,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
