import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/dialog_buttom_vitals/mostrar_dialog_selector.dart';
import '../../layout/layout_scaffold.dart';
import '../../providers/signal_vitals/signal_vital_provider.dart';
import '../../widgets/vitals/vital_card.dart';

class VitalsScreen extends StatelessWidget {
  const VitalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signos = Provider.of<SignosVitalesProvider>(context).signos;

    return LayoutScaffold(
      title: "SIGNOS VITALES",
      useMaternalBackground: true,
      bottomNav: null,
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
              //TARJETA DE SIGNO VITAL DESDE SMARTWATCH
              VitalCard(
                icon: Icons.favorite_border,
                title: "Frecuencia cardíaca",
                value:
                    signos != null ? "${signos.frecuenciaCardiaca} " : "-- bpm",
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              // 🌡️ Temperatura
              /* VitalCard(
                icon: Icons.thermostat_outlined,
                title: "Temperatura",
                value: "36.7 °C",
                color: Colors.orange,
              ),
              const SizedBox(height: 16),*/

              // 💨 Oxigenación
              VitalCard(
                icon: Icons.bubble_chart_outlined,
                title: "Oxigenación",
                value: signos != null ? signos.oxigenacion : "-- %",
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
              //BOTÓN PARA IR AL HISTORIAL DE SINTOMAS
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/historialSignosVitales');
                  },
                  icon: const Icon(Icons.history),
                  label: const Text(
                    "Ver historial",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
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
              // BOTÓN PARA IR AL HISTORIAL DE EVALUACIONES
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/historialEvaluaciones');
                  },
                  icon: const Icon(Icons.health_and_safety),
                  label: const Text(
                    "Historial de evaluaciones",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
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
