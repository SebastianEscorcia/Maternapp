import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Routes/routes.dart';
import '../../layout/layout_scaffold.dart';
import '../../providers/familiar/familiar_provider.dart';
import '../../providers/Auth/auth_provider.dart';

class WelcomeFamiliarScreen extends StatelessWidget {
  const WelcomeFamiliarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<FamiliarProvider>(context, listen: false);
      if (provider.familiar == null) {
        provider.inicializarFamiliar(null);
      }
    });

    return LayoutScaffold(
      title: "Modo Familiar 🤝",
      useMaternalBackground: true,
      showBack: true,
      centerContent: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "¡Bienvenid@ al modo Familiar!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Lottie.asset(
                'assets/animations/family2.json',
                width: 200,
                repeat: true,
              ),
              const SizedBox(height: 16),
              const Text(
                "Podrás apoyar a tu pareja o familiar en su proceso de embarazo.\n\nPronto te guiaremos para vincular tu cuenta.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.questionFamiliarScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[300],
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                child: const Text(
                  "Siguiente",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              Text("¿Ya tienes cuenta?",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink[800],
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.pink,
                  elevation: 4,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: Colors.pinkAccent),
                  ),
                ),
                icon: const Icon(Icons.login),
                label: const Text("Iniciar sesión con Google"),
                onPressed: () async {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  final familiarProvider = Provider.of<FamiliarProvider>(context, listen: false);
                  final prefs = await SharedPreferences.getInstance();

                  final user = await authProvider.signInWithGoogle();

                  if (user != null) {
                    final uid = user.uid;

                    await familiarProvider.cargarFamiliarFirebase(uid);
                    final familiar = familiarProvider.familiar;

                    if (familiar != null) {
                      await prefs.setString('familiarUid', uid);
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, Routes.mainScaffoldNavbarFamiliar);
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              '¡Hola! Aún no has creado tu perfil familiar 👨‍👩‍👧. Te guiaremos para hacerlo 💖',
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.pinkAccent,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 3),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16))),
                          ),
                        );

                        await Future.delayed(const Duration(seconds: 3));
                        Navigator.pushReplacementNamed(
                            context, Routes.questionFamiliarScreen);
                      }
                    }
                  } else if (!authProvider.userCancelledLogin && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(authProvider.errorMesagge ?? 'Error al iniciar sesión'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
