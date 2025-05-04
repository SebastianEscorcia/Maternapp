import 'package:maternapp/domain/services/maternal_services.dart';

import '../../presentation/providers/calendar_provider.dart';
import '../../presentation/providers/maternal_draft_provider.dart';
import '../../presentation/providers/maternal_provider.dart';

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
    if (draft.anioNacimiento == null)
      return "Por favor, selecciona tu año de nacimiento.";

    final edadCalculada = DateTime.now().year - draft.anioNacimiento!;
    if (edadCalculada <= 0) return "La edad no es válida.";
    if (edadCalculada <= 10) return "Estás muy pequeña para quedar embarazada.";

    if (draft.peso == null || draft.peso! < 30 || draft.peso! > 150)
      return "El peso debe estar entre 30 y 150 kg.";
    if (draft.estatura == null ||
        draft.estatura! < 1.20 ||
        draft.estatura! > 2.00)
      return "La estatura debe estar entre 1.20 m y 2.00 m.";

    if (calendar.selectedDay == null)
      return "Selecciona la fecha de tu última menstruación.";
    if (calendar.dueDate == null || calendar.weeksPregnant == 0)
      return "La fecha no es válida.";

    return null;
  }

  void procesarFormulario() {
    calendarProvider.model.maternaId = draftProvider.draft.uId ?? '';
    final materna = maternaService.construirMaterna(
      draftProvider.draft,
      calendarProvider.model,
    );
    maternaProvider.setMaterna(materna);
  }

  Future<void> guardarMaternaYCalendario() async {
    final draft = draftProvider.draft;

    await maternaProvider.crearOActualizarMaternaFirebase(draft);

    calendarProvider.model.maternaId = draft.uId!;
    await calendarProvider.crearCalendarioFirebase();
  }
}
