import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importa esto para inicializar locales
import 'package:provider/provider.dart';
import 'package:maternapp/Routes/routes.dart';
import 'package:maternapp/presentation/screens/home/calendar_screen.dart';
import 'package:maternapp/presentation/screens/home/home_screens.dart';
import 'package:maternapp/controllers/calendar_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegúrate de inicializar el binding
  await initializeDateFormatting('es_ES', null); // Inicializa el formato regional para fechas
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CalendarController()),
      ],
      child: const MyApp(),
    ),
  );
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
      locale: const Locale('es', 'ES'),
      initialRoute: Routes.homeScreen,
      routes: {
        Routes.homeScreen: (context) => const HomeScreens(),
        Routes.calendarScreen: (context) => const CalendarScreen(),
      },
    );
  }
}
