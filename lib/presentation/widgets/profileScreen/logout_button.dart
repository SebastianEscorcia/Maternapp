import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Routes/routes.dart';
import '../../providers/Auth/auth_provider.dart';
import '../../providers/maternal_provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    if(user == null) return const SizedBox.shrink();
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _confirmLogout(context),
        icon: const Icon(Icons.logout),
        label: const Text("Cerrar sesión"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[300],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final maternaProvider =
        Provider.of<MaternaProvider>(context, listen: false);

    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("¿Cerrar sesión?"),
            content: const Text(
              "¿Estás segura de que deseas cerrar sesión? Esta acción no eliminará tus datos.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Cerrar sesión"),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    // Mostrar animación de salida
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
              const Text("Cerrando sesión...", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    await authProvider.signOut();
    maternaProvider.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (context.mounted) {
      Navigator.pop(context); // Cierra el dialog
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.welcomeScreen,
        (route) => false,
      );
    }
  }
}
