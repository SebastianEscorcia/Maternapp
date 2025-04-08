import 'package:flutter/material.dart';
import 'package:maternapp/domain/services/calendar_services.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/models/calendar_model.dart';


class CalendarController extends ChangeNotifier {
  final CalendarModel model = CalendarModel(focusedDay: DateTime.now());
  final CalendarService _calendarService = CalendarService();

  CalendarFormat _calendarFormat = CalendarFormat.month;

  CalendarFormat get calendarFormat => _calendarFormat;
  DateTime get focusedDay => model.focusedDay;
  DateTime? get selectedDay => model.selectedDay;
  int get weeksPregnant => model.weeksPregnant;
  DateTime? get dueDate => model.dueDate;
  String get trimesterMessage => model.trimesterMessage;
  Color get weekColor => model.weekColor;
  DateTime get lastDayYear => model.lastDayYear ?? DateTime(DateTime.now().year + 1, 12, 31);

  set lastDayYear(DateTime time) {
    model.lastDayYear = time;
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
