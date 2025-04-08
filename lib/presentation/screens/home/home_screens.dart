import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maternapp/core/providers/maternal_provider.dart';
import 'package:maternapp/presentation/global_widgets/texts/app_text.dart';
import 'package:provider/provider.dart';
import 'package:maternapp/presentation/layout/layout_scaffold.dart';
import 'package:maternapp/presentation/screens/home/widgets/navbar/botton_navbar.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final materna = Provider.of<MaternaProvider>(context).materna;

    return LayoutScaffold(
      bottomNav: const BottonNavbar(),
      centerContent: true, // 👈 Activa el centrado vertical
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            text: '¡Hola ${materna?.nombre ?? 'mamá'}! 💖',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
            align: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (materna != null) ...[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              color: Colors.pink[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(text: 'Edad: ${materna.edad} años'),
                    AppText(
                        text:
                            'Semanas de embarazo: ${materna.semanasGestacion == -1 ? 'Menos de una' : materna.semanasGestacion}'),
                    AppText(
                        text:
                            'Fecha probable de parto: ${DateFormat('dd MMMM yyyy', 'es_ES').format(materna.fechaEstimadaParto)}'),
                  ],
                ),
              ),
            ),
          ] else ...[
            const Text('No se encontró información de la materna.'),
          ],
          const SizedBox(height: 30),
          Image.asset(
            'assets/images/maternapp.png',
            width: 180,
            height: 180,
          ),
        ],
      ),
    );
  }
}
