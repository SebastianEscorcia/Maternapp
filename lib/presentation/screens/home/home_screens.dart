import 'package:flutter/material.dart';
import 'package:maternapp/presentation/screens/home/widgets/navbar/botton_navbar.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
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
      bottomNavigationBar: const BottonNavbar(), 
    );
  }
}
