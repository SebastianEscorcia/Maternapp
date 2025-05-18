import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:maternapp/presentation/providers/maternal_provider.dart';
import 'package:maternapp/presentation/layout/layout_scaffold.dart';
import 'package:maternapp/presentation/widgets/texts/app_text.dart';

import '../../widgets/sintoma/registrar_sintoma_buttom.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({super.key});

  Future<bool> _cargarMaterna(BuildContext context) async {
    final provider = Provider.of<MaternaProvider>(context, listen: false);
    if (provider.materna == null) {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('maternaUid');
      if (uid != null && uid.isNotEmpty) {
        await provider.cargarMaternaFirebase(uid);
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _cargarMaterna(context),
      builder: (context, snapshot) {
        final materna = context.watch<MaternaProvider>().materna;

        if (snapshot.connectionState != ConnectionState.done || materna == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return LayoutScaffold(
          useMaternalBackground: true,
          centerContent: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //  Saludo
                AppText(
                  text: '¡Hola ${materna.nombre}! 💖',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // 📋 Datos
                Card(

                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    side:  BorderSide(
                      color: Colors.pink.shade50, width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  shadowColor: Colors.pink.withAlpha(100),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // Nombre
                        _infoRow(Icons.cake, 'Edad', '${materna.edad} años'),
                        const SizedBox(height: 12),
                        _infoRow(
                          Icons.pregnant_woman,
                          'Semanas de embarazo',
                          materna.semanasGestacion == -1
                              ? 'Menos de una'
                              : '${materna.semanasGestacion}',
                        ),
                        const SizedBox(height: 12),
                        // Fecha de última regla
                        _infoRow(
                          Icons.calendar_today_outlined,
                          'Fecha probable de parto',
                          DateFormat('dd MMMM yyyy', 'es_ES')
                              .format(materna.fechaEstimadaParto),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 📷 Imagen branding
                Image.asset(
                  'assets/images/maternapp.png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                ),

               const SizedBox(height: 30),
                const RegistrarSintomaButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.pink[300], size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
