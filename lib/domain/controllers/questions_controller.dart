import 'package:maternapp/core/providers/maternal_draft_provider.dart';
import 'package:maternapp/core/providers/maternal_provider.dart';
import 'package:maternapp/data/models/maternal_model.dart';
import 'package:maternapp/domain/controllers/calendar_controller.dart';
import 'package:maternapp/domain/controllers/maternal_controller.dart';
import 'package:maternapp/domain/services/maternal_services.dart';
import 'package:maternapp/domain/services/questions_services.dart';

class PreguntaController {
  final MaternaDraftProvider draftProvider;
  final CalendarController calendarController;
  final QuestionsServices preguntaService;
  final MaternalService maternaService;
  final MaternalController maternaController;
  final MaternaProvider maternaProvider;

  PreguntaController({
    required this.draftProvider,
    required this.calendarController,
    required this.preguntaService,
    required this.maternaService,
    required this.maternaController,
    required this.maternaProvider,
  });

  /// ✅ Valida los campos del formulario usando el servicio
  String? validarFormulario() {
    return preguntaService.validarFormulario(
      draftProvider.draft,
      calendarController.model,
    );
  }

  /// ✅ Procesa y guarda el modelo final de Materna
  void procesarFormulario() {
    final Materna materna = maternaController.crear(
      draft: draftProvider.draft,
      calendario: calendarController.model,
    );

    maternaProvider.setMaterna(materna);
  }
}
