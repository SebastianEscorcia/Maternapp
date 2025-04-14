import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importa esto para inicializar locales
import 'package:maternapp/core/appProvider/app_providers.dart';
import 'package:maternapp/presentation/screens/questions/questions_screen.dart';
import 'package:maternapp/presentation/screens/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:maternapp/Routes/routes.dart';
import 'package:maternapp/presentation/widgets/home/calendar/calendar_screen.dart';
import 'package:maternapp/presentation/screens/home/home_screens.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegúrate de inicializar el binding
  await initializeDateFormatting('es_ES', null);
  runApp(
    MultiProvider(
      providers: AppProviders.obterProvider,
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
         colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink[300] ?? Colors.pink),
      ),
      locale: const Locale('es', 'ES'),
      initialRoute: Routes.welcomeScreen,
      routes: {
        Routes.homeScreen: (context) => const HomeScreens(),
        Routes.calendarScreen: (context) => const CalendarScreen(),
        Routes.questionScreen: (conntext) => const QuestionScreen(),
        Routes.welcomeScreen: (context) => const WelcomeScreen(),
      },
    );
  }
}
