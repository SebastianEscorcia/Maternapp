import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
    final familiarId = prefs.getString('familiarUid');

    // Simular un retraso para mostrar la pantalla de carga
    await Future.delayed(const Duration(seconds: 2));

    // ✅ Prioriza al familiar si está logueado
    if (familiarId != null && familiarId.isNotEmpty) {
      return Routes.mainScaffoldNavbarFamiliar;
    }
    final maternaProvider =
        Provider.of<MaternaProvider>(context, listen: false);
    final calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);

    if (maternaId != null) {
      await maternaProvider.cargarMaternaFirebase(maternaId);

      if (maternaProvider.materna != null) {
        if (calendarioId != null && calendarioId.isNotEmpty) {
          await calendarProvider.cargarCalendario(calendarioId);
          return Routes.mainScaffoldNavbar;
        } else {
          return Routes.calendarScreen;
        }
      }
    }

    return Routes.inicio;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return FutureBuilder<String>(
      future: _verificarSesion(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFCE4EC), // Rosa claro
                    Color(0xFFF8BBD0), // Rosa medio
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Elementos decorativos sutiles
                  Positioned(
                    top: screenSize.height * 0.1,
                    left: screenSize.width * 0.1,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(Icons.child_care,
                          size: 60, color: Colors.pink[300]),
                    ),
                  ),
                  Positioned(
                    bottom: screenSize.height * 0.15,
                    right: screenSize.width * 0.15,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(Icons.pregnant_woman,
                          size: 70, color: Colors.pink[300]),
                    ),
                  ),
                  Positioned(
                    top: screenSize.height * 0.3,
                    right: screenSize.width * 0.1,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(Icons.favorite,
                          size: 50, color: Colors.pink[300]),
                    ),
                  ),
                  // Contenido central
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Lottie.asset(
                            'assets/animations/women_pregnant.json',
                            width: 250,
                            repeat: true,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'MaternApp',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD81B60),
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.pink.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tu compañera en el camino',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.pink[700],
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            color: Color(0xFFD81B60),
                            strokeWidth: 3,
                            backgroundColor: Colors.pink[100],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Texto de copyright en la parte inferior
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Text(
                      '© MaternApp 2025',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.pink[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        //  Redirige cuando termina el Future
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, snapshot.data!);
        });

        return const SizedBox.shrink(); // Mientras redirige, no muestra nada
      },
    );
  }
}
