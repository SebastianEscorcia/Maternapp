import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/dialog_buttom_vitals/mostrar_dialog_selector.dart';
import '../../layout/layout_scaffold.dart';
import '../../widgets/vitals/vital_card.dart';
import '../../providers/navigation_navbar_provider.dart';
import '../../widgets/home/navbar/botton_navbar.dart';

class VitalsScreen extends StatelessWidget {
  const VitalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationNavbarProvider>(context);
    final isInsideMainFlow = ModalRoute.of(context)?.isFirst ?? false;

    return LayoutScaffold(
      useMaternalBackground: true,
      centerContent: false,
      bottomNav: isInsideMainFlow
          ? null
          : BottonNavbar(
              currentIndex: navProvider.currentIndex,
              onTap: (index) => navProvider.irAPestania(context, index),
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🩺 Encabezado
              const Text(
                "👩‍⚕️ Salud en tiempo real",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Consulta y registra tus signos vitales con precisión.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // 💓 Frecuencia cardíaca
              VitalCard(
                icon: Icons.favorite_border,
                title: "Frecuencia cardíaca",
                value: "72 bpm",
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),

              // 🌡️ Temperatura
              VitalCard(
                icon: Icons.thermostat_outlined,
                title: "Temperatura",
                value: "36.7 °C",
                color: Colors.orange,
              ),
              const SizedBox(height: 16),

              // 💨 Oxigenación
              VitalCard(
                icon: Icons.bubble_chart_outlined,
                title: "Oxigenación",
                value: "98 %",
                color: Colors.blue,
              ),

              const SizedBox(height: 40),

              // ⌚ Botón de conexión a smartwatch
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => mostrarSelectorSmartwatch(context),
                  icon: const Icon(Icons.watch),
                  label: const Text(
                    "Conectar reloj inteligente",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[300],
                    foregroundColor: Colors.white,
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
