import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../domain/services/calendar_services.dart';
import '../../domain/services/maternal_services.dart';
import '../../presentation/providers/calendar_provider.dart';
import '../../presentation/providers/maternal_draft_provider.dart';
import '../../presentation/providers/maternal_provider.dart';
import '../../presentation/providers/navigation_navbar_provider.dart';
import '../../presentation/providers/next_or_previous_questions_provider.dart';

class AppProviders {
  static List<SingleChildWidget> get obterProvider => [
        // Servicios base
        Provider<CalendarService>(create: (_) => CalendarService()),
        Provider<MaternalService>(create: (_) => MaternalService()),

        // Providers puros
        ChangeNotifierProvider<MaternaDraftProvider>(
          create: (_) => MaternaDraftProvider(),
        ),
        ChangeNotifierProvider<CalendarProvider>(
          create: (_) => CalendarProvider(),
        ),
        ChangeNotifierProvider<NextOrPreviousQuestionsProvider>(
          create: (_) => NextOrPreviousQuestionsProvider(),
        ),
         ChangeNotifierProvider(create: (_) => NavigationNavbarProvider()),
    
    
        // ✅ ProxyProvider para inyectar MaternalService en MaternaProvider
        ChangeNotifierProxyProvider<MaternalService, MaternaProvider>(
          create: (_) => MaternaProvider(maternalService: MaternalService()), // valor temporal, será reemplazado abajo
          update: (_, maternalService, previous) =>
              MaternaProvider(maternalService: maternalService),
        ),
      ];
}
