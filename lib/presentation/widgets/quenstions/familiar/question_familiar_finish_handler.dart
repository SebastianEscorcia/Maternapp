import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../../../../Routes/routes.dart';
import '../../../providers/familiar/familiar_provider.dart';

Future<void> onFinalizarFamiliar(BuildContext context) async {
  final familiarProvider = context.read<FamiliarProvider>();

  final familiar = familiarProvider.familiar;
  if (familiar == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Familiar no definido. Verifica los datos."),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Mostrar diálogo de carga
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
            SizedBox(
              height: 100,
              width: 100,
              child: Lottie.asset('assets/animations/loading_heart.json',
                  repeat: true),
            ),
            const SizedBox(height: 20),
            const Text("Guardando tu información...",
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ),
  );

  try {
    await familiarProvider.validarVincularYGuardar();

    final actualizado = familiarProvider.familiar!;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('familiarUid', actualizado.uId!);
    await prefs.reload();

    Navigator.pop(context); // Cierra el modal de carga

    // Diálogo de éxito
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: Lottie.asset('assets/animations/success.json',
                    repeat: false),
              ),
              const SizedBox(height: 20),
              const Text(
                "¡Perfecto!",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF4B8A)),
              ),
              const SizedBox(height: 10),
              const Text(
                "Te has vinculado correctamente con tu ser querido.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, Routes.splashScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4B8A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text("Continuar",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  } catch (e) {
    Navigator.pop(context); // Cierra el modal de carga si hay error
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
              child: Text(e.toString().replaceAll('Exception:', '').trim())),
        ],
      ),
      backgroundColor: Colors.red[400],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}
