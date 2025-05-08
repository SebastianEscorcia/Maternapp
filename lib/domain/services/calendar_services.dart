import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maternapp/data/models/calendar_model.dart';

class CalendarService {
  final String calendarCollection = 'calendars';
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<void> crearCalendarioFirebase(CalendarModel calendar) async {
    final batch = _firestore.batch();

    final calendarioRef =
        _firestore.collection(calendarCollection).doc(calendar.uId);
    batch.set(calendarioRef, calendar.toJson());

    await batch.commit(); // ✅ Esto es indispensable
  }

  Future<void> actualizarCalendario(CalendarModel calendar) async {
    if (calendar.uId.isEmpty) {
    throw Exception("❌ UID de calendario vacío. No se puede actualizar.");
  }
    try {
      await _firestore
          .collection(calendarCollection)
          .doc(calendar.uId)
          .set(calendar.toJson(), SetOptions(merge: true));
    } catch (e) {
      print("Error en actualizar el calendario: $e");
    }
  }

  Future<CalendarModel?> obtenerCalendario(String uid) async {
    final doc = await _firestore.collection(calendarCollection).doc(uid).get();
    if (doc.exists) return CalendarModel.fromJson(doc.data()!);
    return null;
  }

  void calcularDetalles(CalendarModel model) {
    if (model.selectedDay == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(
      model.selectedDay!.year,
      model.selectedDay!.month,
      model.selectedDay!.day,
    );

    final difference = today.difference(selectedDate).inDays;

    if (difference <= 0) {
      model.weeksPregnant = 0;
      model.dueDate = null;
      model.trimesterMessage =
          "Tu último periodo no puede ser mayor o igual a la fecha actual";
      model.weekColor = Colors.black;
      return;
    }

    model.weeksPregnant = difference < 7 ? -1 : (difference / 7).floor();
    model.dueDate = selectedDate.add(const Duration(days: 280));

    model.trimesterMessage = _mensajePorTrimestre(model.weeksPregnant);
    model.weekColor = _colorPorTrimestre(model.weeksPregnant);
  }

  String _mensajePorTrimestre(int semanas) {
    if (semanas < 13 && semanas > 0) {
      return "🌱 Primer Trimestre: Desarrollo inicial del bebé. Es normal sentir náuseas y cansancio.";
    } else if (semanas < 27 && semanas > 12) {
      return "🌟 Segundo Trimestre: El bebé empieza a moverse. Es un buen momento para ecografías.";
    } else if (semanas < 40 && semanas > 26) {
      return "🤰 Tercer Trimestre: Prepara la llegada del bebé. Vigila las contracciones y síntomas.";
    } else if (semanas == 40) {
      return "🎉 ¡Felicidades! Tu embarazo ya ha alcanzado el término. El parto puede ser en cualquier momento.";
    }
    return "";
  }

  Color _colorPorTrimestre(int semanas) {
    if (semanas < 13) return Colors.green;
    if (semanas < 27) return Colors.orange;
    if (semanas < 40) return Colors.red;
    return Colors.blue;
  }

  bool esFechaValida(DateTime fecha) {
    final hoy = DateTime.now();
    final sinHora = DateTime(hoy.year, hoy.month, hoy.day);
    final seleccion = DateTime(fecha.year, fecha.month, fecha.day);
    return seleccion.isBefore(sinHora);
  }
}
