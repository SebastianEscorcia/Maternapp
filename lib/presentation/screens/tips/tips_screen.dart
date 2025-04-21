import 'package:flutter/material.dart';
import 'package:maternapp/presentation/layout/layout_scaffold.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutScaffold(
      title: "Consejos para ti 💡",
      centerContent: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Aquí encontrarás recomendaciones personalizadas para tu embarazo.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          // Aquí puedes poner una lista de tarjetas con tips
        ],
      ),
    );
  }
}
