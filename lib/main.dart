import 'package:flutter/material.dart';
import 'package:maternapp/Routes/routes.dart';
import 'package:maternapp/presentation/screens/home/calendar_screen.dart';
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
        locale: Locale('es', 'ES'),
        initialRoute: Routes.homeScreen,
        routes: {
          Routes.homeScreen: (context) => const HomeScreens(),
          Routes.calendarScreen: (context) => const CalendarScreen(),
        });
  }
}
