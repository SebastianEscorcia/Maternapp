import 'package:flutter/material.dart';
import 'package:maternapp/presentation/layout/layout_scaffold.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      {
        "title": "Mantente hidratada 💧",
        "content": "Bebe al menos 8 vasos de agua al día para favorecer el desarrollo del bebé y tu bienestar."
      },
      {
        "title": "Descansa lo suficiente 😴",
        "content": "Dormir bien mejora tu salud física y emocional durante el embarazo."
      },
      {
        "title": "Consulta con tu médico 🩺",
        "content": "Lleva un control prenatal regular para prevenir complicaciones."
      },
    ];

    return LayoutScaffold(
      useMaternalBackground: true,
      centerContent: false,
      title: "Consejos útiles 🧘‍♀️",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Aquí encontrarás recomendaciones personalizadas para tu embarazo.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // Lista de tarjetas con borde personalizado
            ...tips.map((tip) => _TipCard(
                  title: tip["title"]!,
                  content: tip["content"]!,
                )),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String title;
  final String content;

  const _TipCard({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.pink.shade50,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      shadowColor: Colors.pink.withAlpha(100),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
