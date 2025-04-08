import 'package:maternapp/core/providers/maternal_draft_provider.dart';
import 'package:maternapp/core/providers/maternal_provider.dart';
import 'package:maternapp/core/providers/next_or_previous_questions_provider.dart';
import 'package:maternapp/domain/controllers/calendar_controller.dart';
import 'package:maternapp/domain/controllers/maternal_controller.dart';
import 'package:maternapp/domain/services/calendar_services.dart';
import 'package:maternapp/domain/services/maternal_services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  // SingleChildWidget para que puedas mezclar ChangeNotifierProvider y Provider en una sola lista
  static List<SingleChildWidget> get obterProvider => [
    ChangeNotifierProvider <MaternaDraftProvider>(create: (context) => MaternaDraftProvider()),
    ChangeNotifierProvider <MaternaProvider>(create: (context) => MaternaProvider()), 
    ChangeNotifierProvider <CalendarController>(create: (context) => CalendarController()),
    ChangeNotifierProvider <NextOrPreviousQuestionsProvider>(create: (context)=> NextOrPreviousQuestionsProvider()),
    
    //SERVICIOS PUROS
    Provider<CalendarService>(create: (_) => CalendarService()),
    Provider<MaternalService>(create: (_) => MaternalService()),

    //CONTROLLADORES
    Provider<MaternalController>(
      create: (context) => MaternalController(
        maternalService: Provider.of<MaternalService>(context, listen: false),
      ),
    ),
  ];
}
