import 'package:flutter/material.dart';
import 'package:maternapp/presentation/layout/layout_scaffold.dart';

import '../../widgets/vitals/vital_card.dart';

class VitalsScreen extends StatelessWidget {
  const VitalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutScaffold(
      title: "Signos vitales 🩺",
      centerContent: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Aquí puedes registrar o consultar tus signos vitales.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),

          // tarjeta de frecuencia cardíaca
          VitalCard(
            icon: Icons.favorite_border,
            title: "Frecuencia cardíaca",
            value: "72 bpm",
            color: Colors.redAccent,
          ),

          const SizedBox(height: 16),

          //  tarjeta de temperatura
          VitalCard(
            icon: Icons.thermostat_outlined,
            title: "Temperatura",
            value: "36.7 °C",
            color: Colors.orange,
          ),

          const SizedBox(height: 16),

          //  tarjeta de oxigenación
          VitalCard(
            icon: Icons.bubble_chart_outlined,
            title: "Oxigenación",
            value: "98 %",
            color: Colors.blue,
          ),

          const SizedBox(height: 32),

          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Aquí puedes abrir una pantalla de lectura automática o formulario
              },
              icon: const Icon(Icons.monitor_heart),
              label: const Text("Tomar signos ahora"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
