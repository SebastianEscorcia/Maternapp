import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../layout/layout_scaffold.dart';
import '../../../widgets/texts/app_text.dart';


class MaternaInfoScreen extends StatelessWidget {
  const MaternaInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutScaffold(
      title: 'Tu materna ❤️',
      useMaternalBackground: true,
      centerContent: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: "Estado de tu ser querido",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Nombre: Camila", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Semanas de embarazo: 22",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Fecha estimada de parto: 14 septiembre 2025",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Síntomas recientes: fatiga, náuseas",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Lottie.asset('assets/animations/baby.json', height: 150),
          ],
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutScaffold(
      title: 'Notificaciones 🚨',
      useMaternalBackground: true,
      centerContent: false,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _NotificationCard(
            message:
                "Alerta: la temperatura de Camila fue registrada en 38.2 °C",
            timestamp: "hace 10 min",
          ),
          _NotificationCard(
            message:
                "Nuevo síntoma reportado: mareo",
            timestamp: "hace 2 horas",
          ),
          _NotificationCard(
            message: "Signos vitales normales esta mañana. ✨",
            timestamp: "hoy a las 8:30 a.m.",
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String message;
  final String timestamp;

  const _NotificationCard({
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.notifications_active, color: Colors.pink),
        title: Text(message),
        subtitle: Text(timestamp),
      ),
    );
  }
}
