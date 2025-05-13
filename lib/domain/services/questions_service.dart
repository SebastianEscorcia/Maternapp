import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/calendar_model.dart';
import '../../data/models/drafts/maternal_draft.dart';
import '../../presentation/providers/maternal_draft_provider.dart';
import '../../presentation/providers/maternal_provider.dart';
import '../../presentation/providers/calendar_provider.dart';
import 'calendar_services.dart';
import 'maternal_services.dart';

class QuestionService {
  final MaternaDraftProvider draftProvider;
  final CalendarProvider calendarProvider;
  final MaternaProvider maternaProvider;
  final CalendarService calendarService;
  final MaternalService maternalService;

  QuestionService({
    required this.draftProvider,
    required this.calendarProvider,
    required this.maternaProvider,
    required this.calendarService,
    required this.maternalService,
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

  Future<void> guardarMaternaYCalendario({
    required MaternaDraft draft,
    required CalendarModel calendar,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if ((draft.uId == null || draft.uId!.isEmpty) && user != null) {
      draft.uId = user.uid;
    }
    if (calendar.selectedDay == null ||
        !calendarService.esFechaValida(calendar.selectedDay!)) {
      throw Exception("Fecha seleccionada inválida. Debe ser anterior a hoy.");
    }

    // ✅ Calcula detalles (color, semanas, mensaje, etc.)
    calendarService.calcularDetalles(calendar);

    // ✅ GENERA UID SI ESTÁ VACÍO
    if (calendar.uId.isEmpty) {
      calendar.uId =
          FirebaseFirestore.instance.collection('calendars').doc().id;
    }

    // 🔄 Guarda o actualiza calendario
    final calendarioExistente =
        await calendarService.obtenerCalendario(calendar.uId);
    if (calendarioExistente == null) {
      await calendarService.crearCalendarioFirebase(calendar);
    } else {
      await calendarService.actualizarCalendario(calendar);
    }

    // 🔄 Asigna ID del calendario al draft
    draft.calendarId = calendar.uId;

    // 🔄 Guarda o actualiza la materna
    String maternaUid;
    if (draft.uId != null && draft.uId!.isNotEmpty) {
      final maternaExistente =
          await maternalService.obternerMaterna(draft.uId!);
      if (maternaExistente != null) {
        await maternalService.actualizarMaternaFirebase(draft, calendar);
        maternaUid = draft.uId!;
      } else {
        maternaUid =
            await maternalService.crearMaternaFirebase(draft, calendar);
        draft.uId = maternaUid;
      }
    } else {
      maternaUid = await maternalService.crearMaternaFirebase(draft, calendar);
      draft.uId = maternaUid;
    }

    // 🔁 Asigna ID de materna al calendario y actualiza
    calendar.maternaId = maternaUid;
    await FirebaseFirestore.instance
        .collection('maternas')
        .doc(maternaUid)
        .update({'calendarioId': calendar.uId});
    await calendarService.actualizarCalendario(calendar);
  }
}
