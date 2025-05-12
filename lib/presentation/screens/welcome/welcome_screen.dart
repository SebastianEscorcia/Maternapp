import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maternapp/presentation/widgets/texts/app_text.dart';
import 'package:maternapp/presentation/layout/layout_scaffold.dart';
import 'package:maternapp/presentation/widgets/welcome/started_button_welcome.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutScaffold(
      title: "", 
      centerContent: true,
      backgroudColor: Color(0xFFFCE4EC),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Contenido principal con efecto de tarjeta
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
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
                      text: "Tu compañera durante esta hermosa etapa.\nControla tu embarazo y tus signos vitales 💕",
                      fontSize: 16,
                      align: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Botón de inicio (ya mejorado)
                    const StartedButtonWelcome(),
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