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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/animations/women_pregnant.json',
            width: 250,
            repeat: true,
          ),
          const SizedBox(height: 30),
          const AppText(
            text: "Bienvenida a MaternApp",
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
            align: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const AppText(
            text: "Tu compañera durante esta hermosa etapa.\nControla tu embarazo y tus signos vitales 💕",
            fontSize: 16,
            align: TextAlign.center,
          ),
          const SizedBox(height: 40),
          StartedButtonWelcome(),
        ],
      ),
    );
  }
}
