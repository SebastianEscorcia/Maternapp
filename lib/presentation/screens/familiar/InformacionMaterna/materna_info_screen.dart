import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/maternal_model.dart';
import '../../../../domain/services/maternal_services.dart';
import '../../../layout/layout_scaffold.dart';
import '../../../providers/sintomas/sintoma_provider.dart';
import '../../../widgets/familiar/maternas_datos_card.dart';
import '../../../widgets/familiar/sintomas_hoy_card.dart';
import '../../../widgets/historial_sintomas/historial_sintomas_familiar_widget.dart';
import '../../../widgets/texts/app_text.dart';

import '../../../providers/familiar/familiar_provider.dart';

class MaternaInfoScreen extends StatelessWidget {
  const MaternaInfoScreen({super.key});

  Future<Materna?> _cargarMaterna(BuildContext context) async {
    final familiar = context.read<FamiliarProvider>().familiar;
    if (familiar == null || familiar.idMaterna == null) return null;

    final maternalService = MaternalService();
    return await maternalService.obternerMaterna(familiar.idMaterna!);
  }

  Future<List<String>> _obtenerSintomasHoy(
      BuildContext context, String maternaUid) async {
    final provider = Provider.of<SintomaProvider>(context, listen: false);

    if (provider.catalogo.isEmpty) {
      await provider.cargarCatalogo();
    }

    final registro = await provider.obtenerSintomasHoySinNotificar(maternaUid);
    return registro?.sintomasIds ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutScaffold(
      title: 'Tu materna ❤️',
      useMaternalBackground: true,
      centerContent: false,
      child: FutureBuilder<Materna?>(
        future: _cargarMaterna(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("No se encontró información de la materna."),
            );
          }

          final materna = snapshot.data!;
          final nombre = materna.nombre;
          final semanas = materna.semanasGestacion;
          final fpp = DateFormat('dd MMMM yyyy', 'es_ES')
              .format(materna.fechaEstimadaParto);

          return FutureBuilder<List<String>>(
            future: () async {
              await Provider.of<SintomaProvider>(context, listen: false)
                  .cargarHistorialDelMesConCache(materna.uid);
              return await _obtenerSintomasHoy(context, materna.uid);
            }(),
            builder: (context, sintomaSnapshot) {
              final sintomasIds = sintomaSnapshot.data ?? [];

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                    MaternaDatosCard(
                      nombre: nombre,
                      semanasGestacion: semanas,
                      fechaPartoFormatted: fpp,
                    ),
                    const SizedBox(height: 20),
                    SintomasHoyCard(
                      sintomasIds: sintomasIds,
                      loading: sintomaSnapshot.connectionState !=
                          ConnectionState.done,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Lottie.asset('assets/animations/baby.json',
                          height: 150),
                    ),
                    const SizedBox(height: 30),
                    const HistorialSintomasFamiliarWidget(),
                  ],
                ),
              );
            },
          );
        },
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
            message: "Nuevo síntoma reportado: mareo",
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
