import 'package:maternapp/data/models/calendar_model.dart';
import 'package:maternapp/data/models/drafts/maternal_draft.dart';

class QuestionsServices {
  
  String? validarFormulario(MaternaDraft draft, CalendarModel calendar) {
    if (draft.nombre == null || draft.nombre!.isEmpty) return "Por favor, ingresa tu nombre.";
    if (draft.edad == null || draft.edad! <= 0) return "Por favor, ingresa una edad válida.";
    if (draft.edad! <= 10) return "Estás muy pequeña para quedar embarazada.";
    if (draft.peso == null || draft.peso! <= 0) return "Por favor, ingresa tu peso.";
    if (draft.estatura == null || draft.estatura! <= 0) return "Por favor, ingresa tu estatura.";
    if (calendar.selectedDay == null) return "Selecciona la fecha de tu última menstruación.";
    if (calendar.dueDate == null || calendar.weeksPregnant == 0) return "La fecha no es válida.";

    return null;
  }


}
