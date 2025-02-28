import 'package:flutter/material.dart';
import 'package:maternapp/presentation/screens/home/widgets/navbar/botton_navbar.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: const Text('MaternApp'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/maternapp.png',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottonNavbar(), // Agregamos el widget aquí
    );
  }
}
