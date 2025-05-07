import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:maternapp/presentation/providers/maternal_provider.dart';
import 'package:maternapp/presentation/widgets/texts/app_text.dart';
import 'package:maternapp/presentation/layout/layout_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  bool _cargando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _verificarCarga();
  }

  Future<void> _verificarCarga() async {
    final provider = Provider.of<MaternaProvider>(context, listen: false);

    if (provider.materna == null) {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('maternaUid');
      if (uid != null && uid.isNotEmpty) {
        await provider.cargarMaternaFirebase(uid);
      }
    }

    if (mounted) {
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final materna = context.watch<MaternaProvider>().materna;

    if (_cargando || materna == null) {
      return const Scaffold(
        body: Center(child: Text('Cargando información...')),
      );
    }

    return LayoutScaffold(
      centerContent: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            text: '¡Hola ${materna.nombre}! 💖',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
            align: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            color: Colors.pink[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: 'Edad: ${materna.edad} años'),
                  AppText(
                    text: 'Semanas de embarazo: ${materna.semanasGestacion == -1 ? 'Menos de una' : materna.semanasGestacion}',
                  ),
                  AppText(
                    text: 'Fecha probable de parto: ${DateFormat('dd MMMM yyyy', 'es_ES').format(materna.fechaEstimadaParto)}',
                  ),
                ],
              ),
            ),
          ),
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
