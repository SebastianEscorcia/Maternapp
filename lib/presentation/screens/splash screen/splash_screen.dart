import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maternapp/Routes/routes.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/maternal_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
    _inicializar();
  }

  Future<void> _inicializar() async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final prefs = await SharedPreferences.getInstance();
    final maternaId = prefs.getString('maternaUid');
    final calendarioId = prefs.getString('calendarioUid');

    if (maternaId != null && calendarioId != null) {
      final maternaProvider =
          Provider.of<MaternaProvider>(context, listen: false);
      final calendarProvider =
          Provider.of<CalendarProvider>(context, listen: false);
      print("SplashScreen → maternaId: $maternaId");
      print("SplashScreen → calendarioId: $calendarioId");
      await maternaProvider.cargarMaternaFirebase(maternaId);
      await calendarProvider.cargarCalendario(calendarioId);

      Navigator.pushReplacementNamed(context, Routes.mainScaffoldNavbar);
    } else {
      Navigator.pushReplacementNamed(context, Routes.welcomeScreen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: FadeTransition(
        opacity: _fadeIn,
        child: Center(
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
      ),
    );
  }
}
