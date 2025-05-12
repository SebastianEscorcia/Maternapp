import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../domain/services/Firebase/auth_services.dart';
import '../../domain/services/calendar_services.dart';
import '../../domain/services/maternal_services.dart';
import '../../domain/services/questions_service.dart';
import '../../presentation/providers/Auth/auth_provider.dart';
import '../../presentation/providers/calendar_provider.dart';
import '../../presentation/providers/materna_edit_provider.dart';
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
        ChangeNotifierProvider.value(value: MaternaDraftProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(
            create: (_) => NextOrPreviousQuestionsProvider()),
        ChangeNotifierProvider(create: (_) => NavigationNavbarProvider()),
        ChangeNotifierProvider(create: (_) => EditMaternaProvider()),

        ChangeNotifierProxyProvider2<MaternalService, CalendarService,
            MaternaProvider>(
          create: (_) => MaternaProvider(
            maternalService: MaternalService(),
            calendarService: CalendarService(),
          ),
          update: (_, maternalService, calendarService, __) => MaternaProvider(
              maternalService: maternalService,
              calendarService: calendarService),
        ),

        // ✅ Después puedes inyectar QuestionService que depende de los anteriores
        ProxyProvider5<MaternaDraftProvider, CalendarProvider, MaternaProvider,
            CalendarService, MaternalService, QuestionService>(
          update: (_, draftProvider, calendarProvider, maternaProvider,
                  calendarService, maternalService, __) =>
              QuestionService(
            draftProvider: draftProvider,
            calendarProvider: calendarProvider,
            maternaProvider: maternaProvider,
            calendarService: calendarService,
            maternalService: maternalService,
          ),
        ),

        // Firebase Auth
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthServices())),
      ];
}
