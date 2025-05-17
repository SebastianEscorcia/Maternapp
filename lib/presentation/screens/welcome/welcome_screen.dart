import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maternapp/presentation/widgets/texts/app_text.dart';
import 'package:maternapp/presentation/layout/layout_scaffold.dart';
import 'package:maternapp/presentation/widgets/welcome/started_button_welcome.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Routes/routes.dart';
import '../../providers/Auth/auth_provider.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/maternal_provider.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutScaffold(
      title: "",
      centerContent: true,
      useMaternalBackground: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Contenido principal con efecto de tarjeta
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Círculo decorativo detrás de la animación
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.pink[50],
                      ),
                      child: Center(
                        child: Lottie.asset(
                          'assets/animations/women_pregnant.json',
                          width: 200,
                          repeat: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Título simplificado
                    const AppText(
                      text: "Bienvenida a MaternApp",
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      align: TextAlign.center,
                    ),

                    const SizedBox(height: 15),

                    // Texto descriptivo normal
                    const AppText(
                      text:
                          "Tu compañera durante esta hermosa etapa.\nControla tu embarazo y tus signos vitales 💕",
                      fontSize: 16,
                      align: TextAlign.center,
                    ),

                    const SizedBox(height: 30),
                    //Botón de inicio
                    const StartedButtonWelcome(),

                    const SizedBox(height: 20),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: const BorderSide(color: Colors.pinkAccent),
                        ),
                      ),
                      icon: const Icon(Icons.login),
                      label: const Text("Iniciar sesión con Google"),
                      onPressed: () async {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        final maternaProvider = Provider.of<MaternaProvider>(
                            context,
                            listen: false);
                        final calendarProvider = Provider.of<CalendarProvider>(
                            context,
                            listen: false);
                        final prefs = await SharedPreferences.getInstance();

                        final user = await authProvider.signInWithGoogle();

                        if (user != null) {
                          final uid = user.uid;

                          await maternaProvider.cargarMaternaFirebase(uid);
                          final materna = maternaProvider.materna;

                          if (materna != null) {
                            await prefs.setString('maternaUid', uid);

                            if (materna.calendarioId.isNotEmpty) {
                              await calendarProvider
                                  .cargarCalendario(materna.calendarioId);
                              await prefs.setString(
                                  'calendarioUid', materna.calendarioId);

                              if (context.mounted) {
                                Navigator.pushReplacementNamed(
                                    context, Routes.mainScaffoldNavbar);
                              }
                            } else {
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(
                                    context, Routes.calendarScreen);
                              }
                            }
                          } else {
                            // No hay materna registrada
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    '¡Hola! Aún no has creado tu perfil materno 🍼. Te guiaremos para hacerlo 💖',
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.pinkAccent,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                ),
                              );

                              await Future.delayed(const Duration(seconds: 2));
                              Navigator.pushReplacementNamed(
                                  context, Routes.questionScreen);
                            }
                          }
                        } else if (!authProvider.userCancelledLogin &&
                            context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(authProvider.errorMesagge ??
                                  'Error al iniciar sesión'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
