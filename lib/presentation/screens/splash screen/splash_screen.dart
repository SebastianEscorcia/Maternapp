import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maternapp/Routes/routes.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/maternal_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<String> _verificarSesion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final maternaId = prefs.getString('maternaUid');
    final calendarioId = prefs.getString('calendarioUid');

    print("SplashScreen → maternaId: $maternaId");
    print("SplashScreen → calendarioId: $calendarioId");

    if (maternaId != null && calendarioId != null) {
      final maternaProvider =
          Provider.of<MaternaProvider>(context, listen: false);
      final calendarProvider =
          Provider.of<CalendarProvider>(context, listen: false);

      await maternaProvider.cargarMaternaFirebase(maternaId);
      await calendarProvider.cargarCalendario(calendarioId);

      return Routes.mainScaffoldNavbar;
    } else {
      return Routes.welcomeScreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _verificarSesion(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.pink[50],
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/maternapp.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'MaternApp',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(color: Colors.pink),
                ],
              ),
            ),
          );
        }

        // ✅ Redirige cuando termina el Future
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, snapshot.data!);
        });

        return const SizedBox.shrink(); // Mientras redirige, no muestra nada
      },
    );
  }
}
