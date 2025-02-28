import 'package:flutter/material.dart';
import 'package:maternapp/presentation/screens/home/home_screens.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MaternApp',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink[300],
      ),
      home: HomeScreens(),
    );
  }
}
