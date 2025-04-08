import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maternapp/core/providers/maternal_provider.dart';
import 'package:provider/provider.dart';
import 'package:maternapp/presentation/screens/home/widgets/navbar/botton_navbar.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final materna = Provider.of<MaternaProvider>(context).materna;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('MaternApp'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenida a MaternApp 👶🏼',
                  style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (materna != null) ...[
                Text('Nombre: ${materna.nombre}'),
                Text('Edad: ${materna.edad} años'),
                Text(' ${materna.semanasGestacion == -1 ? 'Semanas de embarazo: Menos de una' : 'Semanas de embarazo: ${materna.semanasGestacion}'} '),
                Text('Fecha probable de parto: ${DateFormat('dd MMMM yyyy', 'es_ES').format(materna.fechaEstimadaParto)}'),
              ] else ...[
                const Text('No se encontró información de la materna.'),
              ],
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/maternapp.png',
                width: 150,
                height: 150,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottonNavbar(),
    );
  }
}
