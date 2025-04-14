import '../../presentation/providers/maternal_draft_provider.dart';
import '../../presentation/providers/maternal_provider.dart';
import '../../presentation/providers/calendar_provider.dart';
import 'maternal_services.dart';

class QuestionService {
  final MaternaDraftProvider draftProvider;
  final CalendarProvider calendarProvider;
  final MaternalService maternaService;
  final MaternaProvider maternaProvider;

  QuestionService({
    required this.draftProvider,
    required this.calendarProvider,
    required this.maternaService,
    required this.maternaProvider,
  });

  String? validarFormulario() {
    final draft = draftProvider.draft;
    final calendar = calendarProvider.model;

    if (draft.nombre == null || draft.nombre!.isEmpty)
      return "Por favor, ingresa tu nombre.";
    if (draft.edad == null || draft.edad! <= 0)
      return "Por favor, ingresa una edad válida.";
    if (draft.edad! <= 10) return "Estás muy pequeña para quedar embarazada.";
    if (draft.peso == null || draft.peso! <= 0)
      return "Por favor, ingresa tu peso.";
    if (draft.estatura == null || draft.estatura! <= 0)
      return "Por favor, ingresa tu estatura.";
    if (calendar.selectedDay == null)
      return "Selecciona la fecha de tu última menstruación.";
    if (calendar.dueDate == null || calendar.weeksPregnant == 0)
      return "La fecha no es válida.";

    return null;
  }

  void procesarFormulario() {
    final materna = maternaService.construirMaterna(
      draftProvider.draft,
      calendarProvider.model,
    );
    print(materna.nombre);
    maternaProvider.setMaterna(materna);
  }
}
