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

  String? validarFormulario(MaternaDraft draft, CalendarModel calendar) {
    final draft = draftProvider.draft;
    final calendar = calendarProvider.model;

    if (draft.nombre == null || draft.nombre!.isEmpty)
      return "Por favor, ingresa tu nombre.";
    if (draft.anioNacimiento == null)
      return "Por favor, selecciona tu año de nacimiento.";

    final edadCalculada = DateTime.now().year - draft.anioNacimiento!;
    if (edadCalculada <= 0) return "La edad no es válida.";
    if (edadCalculada <= 10) return "Estás muy pequeña para quedar embarazada.";

    if (!draft.pesoRespondido || draft.peso == null || draft.peso! < 30 || draft.peso! > 150)
      return "El peso debe estar entre 30 y 150 kg o no has seleccionado nada ";
    if (!draft.estaturaRespondida || draft.estatura == null ||
        draft.estatura! < 1.20 ||
        draft.estatura! > 2.00)
      return "La estatura debe estar entre 1.20 m y 2.00 m o no has seleccionado nada";

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

    // 🧬 Paso 1: Asignar UID a la materna
    if ((draft.uId == null || draft.uId!.isEmpty)) {
      draft.uId = user?.uid ??
          FirebaseFirestore.instance.collection('maternas').doc().id;
      print("🆕 UID asignado a la materna: ${draft.uId}");
    }

    // 🔐 Validar fecha seleccionada
    if (calendar.selectedDay == null ||
        !calendarService.esFechaValida(calendar.selectedDay!)) {
      throw Exception("Fecha seleccionada inválida. Debe ser anterior a hoy.");
    }

    // 📅 Paso 2: Preparar y guardar calendario
    calendarService.calcularDetalles(calendar);

    if (calendar.uId.isEmpty) {
      calendar.uId =
          FirebaseFirestore.instance.collection('calendars').doc().id;
    }

    final calendarioExistente =
        await calendarService.obtenerCalendario(calendar.uId);
    if (calendarioExistente == null) {
      await calendarService.crearCalendarioFirebase(calendar);
    } else {
      await calendarService.actualizarCalendario(calendar);
    }

    draft.calendarId = calendar.uId;

    // 👩‍🍼 Paso 3: Guardar o actualizar materna
    final maternaExistente = await maternalService.obternerMaterna(draft.uId!);
    if (maternaExistente != null) {
      await maternalService.actualizarMaternaFirebase(draft, calendar);
    } else {
      final nuevoUid =
          await maternalService.crearMaternaFirebase(draft, calendar);
      draft.uId = nuevoUid;
    }

    // 🔗 Paso 4: Asignar calendario a la materna
    calendar.maternaId = draft.uId!;
    await FirebaseFirestore.instance
        .collection('maternas')
        .doc(draft.uId!)
        .update({'calendarioId': calendar.uId});
    await calendarService.actualizarCalendario(calendar);
  }
}
