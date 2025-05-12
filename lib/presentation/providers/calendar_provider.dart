import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maternapp/domain/services/calendar_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/models/calendar_model.dart';

class CalendarProvider extends ChangeNotifier {
  CalendarModel? _model;
  CalendarModel get model => _model!;

  set model(CalendarModel? model) {
    _model = model;
    notifyListeners();
  }

  void setCalendarModel(CalendarModel newModel) {
    _model = newModel;
    notifyListeners();
  }

  CalendarProvider() {
    final generatedId =
        FirebaseFirestore.instance.collection('calendars').doc().id;

    _model = CalendarModel(
      uId: generatedId,
      focusedDay: DateTime.now(),
    );
  }
  final _calendarService = CalendarService();

  CalendarFormat _calendarFormat = CalendarFormat.month;

  CalendarFormat get calendarFormat => _calendarFormat;
  DateTime get focusedDay => model.focusedDay;
  DateTime? get selectedDay => model.selectedDay;
  int get weeksPregnant => model.weeksPregnant;
  DateTime? get dueDate => model.dueDate;
  String get trimesterMessage => model.trimesterMessage;
  Color get weekColor => model.weekColor;
  DateTime get lastDayYear =>
      model.lastDayYear ?? DateTime(DateTime.now().year + 1, 12, 31);

  set lastDayYear(DateTime time) {
    model.lastDayYear = time;
    notifyListeners();
  }

  Future<void> crearCalendarioFirebase(CalendarModel calendar) async {
    try {
      final existe = await _calendarService.obtenerCalendario(calendar.uId);
      if (existe == null) {
        await _calendarService.crearCalendarioFirebase(calendar);
      } else {
        await _calendarService.actualizarCalendario(calendar);
      }
      _model = await _calendarService.obtenerCalendario(calendar.uId);
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> cargarCalendario(String uid) async {
    try {
      final calendario = await _calendarService.obtenerCalendario(uid);
      if (calendario != null) {
        _model = calendario;
        print("✅ Calendario cargado: ${_model?.uId}");
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) print('Error al cargar calendario: $e');
    }
  }

  Future<void> guardarCambiosCalendarioEnFirebase() async {
    if (_model == null || _model!.uId.isEmpty) return;

    try {
      await _calendarService.actualizarCalendario(_model!);
      await guardarCalendarioEnLocal(_model!.uId); // 💾 Guardado en memoria
      if (kDebugMode) print("✅ Calendario actualizado y UID guardado");
    } catch (e) {
      if (kDebugMode) print("❌ Error al actualizar calendario: $e");
    }
  }

  // SE UTILIZA PARA TENER PERSISTENCIA DE LOS DATOS DEL CALENDARIO DESPUÉS DE ACTUALIZARLOS EN MEMORIA
  Future<void> guardarCalendarioEnLocal(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('calendarioUid', uid);
    if (kDebugMode) print("🗂️ UID de calendario guardado localmente: $uid");
  }

  void reiniciarModelo() {
    final nuevoUid =
        FirebaseFirestore.instance.collection('calendars').doc().id;
    _model = CalendarModel(
      uId: nuevoUid,
      focusedDay: DateTime.now(),
    );
    notifyListeners();
  }

  void updateCalendarFormat(CalendarFormat format) {
    _calendarFormat = format;
    notifyListeners();
  }

  void updateFocusedDay(DateTime day) {
    model.focusedDay = day;
    notifyListeners();
  }

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    model.selectedDay = selectedDay;
    model.focusedDay = focusedDay;
    _calendarService.calcularDetalles(model);
    notifyListeners();
  }

  void forzarActualizarFecha(DateTime selectedDay, DateTime focusedDay) {
    model.selectedDay = selectedDay;
    model.focusedDay = focusedDay;
    _calendarService.calcularDetalles(model);
    notifyListeners();
  }

  bool necesitaConfirmacion(DateTime nuevaFecha) {
    return model.selectedDay != null && model.selectedDay != nuevaFecha;
  }

  bool esFechaSeleccionValida(DateTime selectedDay) {
    return _calendarService.esFechaValida(selectedDay);
  }
}
