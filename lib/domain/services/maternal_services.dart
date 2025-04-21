import 'package:maternapp/data/models/calendar_model.dart';
import 'package:maternapp/data/models/drafts/maternal_draft.dart';
import 'package:maternapp/data/models/maternal_model.dart';

class MaternalService {
  Materna construirMaterna(MaternaDraft draft, CalendarModel calendar) {
    return Materna(
      nombre: draft.nombre!,
      edad: DateTime.now().year - draft.anioNacimiento!,
      peso: draft.peso!,
      estatura: draft.estatura!,
      fum: calendar.selectedDay!,
      fechaEstimadaParto: calendar.dueDate ?? calendar.selectedDay!.add(Duration(days: 280)),
      semanasGestacion: calendar.weeksPregnant,
      embarazoActual: draft.embarazoActual,
      esPrimerEmbarazo: draft.esPrimerEmbarazo,
      tipoEmbarazo: draft.tipoEmbarazo,
      tieneAntecedentes: draft.tieneAntecedentes,
    );
  }
}
