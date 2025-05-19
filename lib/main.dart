import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:maternapp/core/appProvider/app_providers.dart';

//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:maternapp/firebase_options.dart';
import 'package:maternapp/presentation/screens/home/home_screens.dart';

// Provider and Routes
import 'package:provider/provider.dart';
import 'package:maternapp/Routes/routes.dart';

// Screens
import 'presentation/layout/main_scaffold_navbar.dart';
import 'presentation/providers/materna_edit_provider.dart';
import 'presentation/providers/maternal_provider.dart';
import 'presentation/providers/sintomas/sintoma_provider.dart';
import 'presentation/screens/SmartWatchs/select_wear_device_screen.dart';
import 'presentation/screens/edit materna/edit_materna_screen.dart';
import 'presentation/screens/historial_sintomas/historial_sintomas_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/questions/questions_screen.dart';
import 'presentation/screens/splash screen/splash_screen.dart';
import 'presentation/screens/tips/tips_screen.dart';
import 'presentation/screens/vitals/vitals_screen.dart';
import 'presentation/screens/welcome/welcome_screen.dart';
import 'presentation/screens/calendar/calendar_screen.dart';

//Navigator key global para el auth provider
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegúrate de inicializar el binding
  await dotenv.load(fileName: 'config/.env');
  await initializeDateFormatting('es_ES', null);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.pink[300] ?? Colors.pink),
      ),
      locale: const Locale('es', 'ES'),
      initialRoute: Routes.splashScreen,
      routes: {
        Routes.splashScreen: (context) => const SplashScreen(),
        Routes.mainScaffoldNavbar: (context) => const MainScaffoldNavbar(),
        Routes.calendarScreen: (context) => const CalendarScreen(),
        Routes.questionScreen: (conntext) => const QuestionScreen(),
        Routes.welcomeScreen: (context) => const WelcomeScreen(),
        Routes.vitalsScreen: (context) => const VitalsScreen(),
        Routes.tipsScreen: (context) => const TipsScreen(),
        Routes.profileScreen: (context) => const ProfileScreen(),
        Routes.editMaternaScreen: (context) {
          final provider =
              Provider.of<EditMaternaProvider>(context, listen: false);
          final materna =
              Provider.of<MaternaProvider>(context, listen: false).materna;
          if (materna != null) provider.cargarDesdeMaterna(materna);
          return const EditMaternaScreen();
        },
        Routes.homeScreen: (context) => const HomeScreens(),
        Routes.selectWearDeviceScreen : (context)  => const SelectWearDeviceScreen(),
        Routes.historialSintomasScreen: (context) {
          final provider =
              Provider.of<SintomaProvider>(context, listen: false);
          final materna =
              Provider.of<MaternaProvider>(context, listen: false).materna;
          if (materna != null) provider.cargarHistorialDelMes(materna.uid);
          return const HistorialSintomasScreen();
        },
      },
    );
  }
}